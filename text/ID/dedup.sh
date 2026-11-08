#!/usr/bin/env bash
# dedup.sh - hapus file duplikat (identik 100%) & mirip (>=90%)
# Usage:
#   ./dedup.sh                 # dry-run (test saja, tidak hapus)
#   ./dedup.sh --apply         # benar-benar hapus
#   ./dedup.sh --apply /path   # target folder lain
#   ./dedup.sh --threshold 85  # ubah ambang kemiripan

set -u

APPLY=0
DIR="."
THRESHOLD=90
SCRIPT_NAME="$(basename "$0")"

while [ $# -gt 0 ]; do
    case "$1" in
        --apply|-y)   APPLY=1 ;;
        --threshold)  THRESHOLD="$2"; shift ;;
        -h|--help)
            sed -n '2,9p' "$0"; exit 0 ;;
        *) DIR="$1" ;;
    esac
    shift
done

[ ! -d "$DIR" ] && { echo "Error: '$DIR' bukan folder" >&2; exit 1; }
cd "$DIR" || exit 1

echo "=== Deduplication scan: $(pwd) ==="
if [ "$APPLY" -eq 1 ]; then
    echo "Mode   : APPLY (file akan dihapus)"
else
    echo "Mode   : DRY-RUN (tambah --apply untuk benar-benar hapus)"
fi
echo "Ambang : >= ${THRESHOLD}% dianggap mirip"
echo

get_size() { stat -c%s "$1" 2>/dev/null || stat -f%z "$1" 2>/dev/null; }

# ---------- STEP 1: file identik (sha256) ----------
declare -A HASH_GROUPS
mapfile -t FILES < <(find . -type f ! -name "$SCRIPT_NAME" ! -path "./.git/*" | sort)
echo "Files ditemukan: ${#FILES[@]}"

for f in "${FILES[@]}"; do
    h=$(sha256sum "$f" | awk '{print $1}')
    HASH_GROUPS["$h"]+="$f"$'\n'
done

declare -A DELETED
EXACT_DEL=0
echo
echo "--- Step 1: file identik (100%) ---"

for h in "${!HASH_GROUPS[@]}"; do
    group=()
    while IFS= read -r line; do
        [ -n "$line" ] && group+=("$line")
    done <<< "${HASH_GROUPS[$h]}"

    [ "${#group[@]}" -le 1 ] && continue

    echo "Grup ${h:0:12}... :"
    for idx in "${!group[@]}"; do
        f="${group[$idx]}"
        if [ "$idx" -eq 0 ]; then
            echo "  KEEP   $f"
        else
            echo "  DELETE $f"
            DELETED["$f"]=1
            EXACT_DEL=$((EXACT_DEL+1))
            [ "$APPLY" -eq 1 ] && rm -f "$f"
        fi
    done
done
[ "$EXACT_DEL" -eq 0 ] && echo "  (tidak ada)"

# ---------- STEP 2: file mirip >= THRESHOLD% ----------
compute_sim() {
    local a="$1" b="$2"
    local la lb max common
    la=$(wc -l < "$a" 2>/dev/null || echo 0)
    lb=$(wc -l < "$b" 2>/dev/null || echo 0)

    if [ "$la" -eq 0 ] && [ "$lb" -eq 0 ]; then
        # file tanpa newline: pakai cmp byte-wise
        if cmp -s "$a" "$b"; then echo 100; else echo 0; fi
        return
    fi

    [ "$la" -gt "$lb" ] && max=$la || max=$lb
    [ "$max" -eq 0 ] && { echo 0; return; }

    # baris yang sama persis (diff akan menghitung common lines)
    common=$(diff --unchanged-line-format='%L' \
                  --old-line-format='' \
                  --new-line-format='' \
                  "$a" "$b" 2>/dev/null | wc -l)
    echo $(( common * 100 / max ))
}

# rebuild (bisa jadi sebagian sudah dihapus di step 1)
mapfile -t FILES < <(find . -type f ! -name "$SCRIPT_NAME" ! -path "./.git/*" | sort)

declare -A ALREADY
SIM_DEL=0
echo
echo "--- Step 2: file mirip (>= ${THRESHOLD}%) ---"

n=${#FILES[@]}
for ((i=0; i<n; i++)); do
    a="${FILES[$i]}"
    [ -f "$a" ] || continue
    [ -n "${ALREADY[$a]:-}" ] && continue

    for ((j=i+1; j<n; j++)); do
        b="${FILES[$j]}"
        [ -f "$b" ] || continue
        [ -n "${ALREADY[$b]:-}" ] && continue

        sa=$(get_size "$a"); sb=$(get_size "$b")
        [ -z "$sa" ] || [ -z "$sb" ] && continue

        # prefilter ukuran: kalau selisih > 2x, mustahil 90% mirip
        big=$sa; small=$sb
        [ "$sb" -gt "$sa" ] && { big=$sb; small=$sa; }
        if [ "$big" -gt 0 ]; then
            pct=$(( small * 100 / big ))
            [ "$pct" -lt 50 ] && continue
        fi

        sim=$(compute_sim "$a" "$b")
        if [ "$sim" -ge "$THRESHOLD" ]; then
            echo "  ${sim}%  $a"
            echo "         <-> $b"
            echo "         DELETE $b"
            ALREADY["$b"]=1
            SIM_DEL=$((SIM_DEL+1))
            [ "$APPLY" -eq 1 ] && rm -f "$b"
        fi
    done
done
[ "$SIM_DEL" -eq 0 ] && echo "  (tidak ada)"

# ---------- SUMMARY ----------
echo
echo "=== Ringkasan ==="
echo "Identik (100%)     : $EXACT_DEL file"
echo "Mirip (>=${THRESHOLD}%)     : $SIM_DEL file"
echo "Total              : $((EXACT_DEL + SIM_DEL)) file"
if [ "$APPLY" -eq 1 ]; then
    echo "Status             : SUDAH DIHAPUS"
else
    echo "Status             : DRY-RUN — jalankan dengan --apply untuk hapus"
fi
