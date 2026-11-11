#!/usr/bin/env bash
#
# rename_jsonl.sh
# Rename semua file *.jsonl menjadi urutan angka (001.jsonl, 002.jsonl, dst.)
#
# Cara pakai:
#   ./rename_jsonl.sh [direktori]
#   (default direktori = direktori saat ini)
#
# Opsi urutan (edit variabel SORT_BY di bawah):
#   name     -> urut berdasarkan nama file (default)
#   time     -> urut berdasarkan waktu modifikasi
#   size     -> urut berdasarkan ukuran file

set -euo pipefail

# ============ KONFIGURASI ============
TARGET_DIR="${1:-.}"
SORT_BY="name"          # name | time | size
DRY_RUN=false           # ubah ke true untuk simulasi tanpa rename
# =====================================

# Validasi direktori
if [[ ! -d "$TARGET_DIR" ]]; then
    echo "ERROR: Direktori '$TARGET_DIR' tidak ditemukan." >&2
    exit 1
fi

cd "$TARGET_DIR"

# Kumpulkan file .jsonl
shopt -s nullglob
files=( *.jsonl )
shopt -u nullglob

if [[ ${#files[@]} -eq 0 ]]; then
    echo "Tidak ada file .jsonl di '$TARGET_DIR'."
    exit 0
fi

# Tentukan urutan
case "$SORT_BY" in
    name) mapfile -t sorted < <(printf '%s\n' "${files[@]}" | sort) ;;
    time) mapfile -t sorted < <(ls -1tr *.jsonl) ;;
    size) mapfile -t sorted < <(ls -1Sr *.jsonl) ;;
    *)    echo "SORT_BY tidak valid: $SORT_BY" >&2; exit 1 ;;
esac

total=${#sorted[@]}

# Hitung lebar padding (minimal 3 digit)
pad=${#total}
(( pad < 3 )) && pad=3

# Cek bentrok: file hasil rename tidak boleh menimpa file asli yang belum di-rename
# Strategi aman: rename dulu ke nama sementara, lalu ke nama final
tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

echo "Ditemukan ${total} file .jsonl (sort: ${SORT_BY}, padding: ${pad} digit)"
$DRY_RUN && echo "== DRY RUN: tidak ada file yang benar-benar diubah =="

# Tahap 1: pindahkan ke nama sementara
i=0
for f in "${sorted[@]}"; do
    i=$((i+1))
    tmpname=$(printf '%s/step1_%0*d.tmp' "$tmpdir" "$pad" "$i")
    if $DRY_RUN; then
        echo "  [DRY] $f -> $(printf '%0*d.jsonl' "$pad" "$i")"
    else
        mv -- "$f" "$tmpname"
    fi
done

# Tahap 2: rename dari temporary ke nama final
if ! $DRY_RUN; then
    i=0
    for f in $(printf '%s\n' "$tmpdir"/step1_*.tmp | sort); do
        i=$((i+1))
        newname=$(printf '%0*d.jsonl' "$pad" "$i")
        mv -- "$f" "./$newname"
        echo "  $newname"
    done
fi

echo "Selesai. ${total} file berhasil di-rename."
