#!/usr/bin/env bash
# Deteksi koma di akhir baris pada file JSONL
# Usage: ./cek_koma_jsonl.sh file.jsonl

FILE="${1:-}"

if [[ -z "$FILE" || ! -f "$FILE" ]]; then
  echo "Usage: $0 <file.jsonl>" >&2
  exit 1
fi

awk '
  {
    line = $0
    trimmed = line
    sub(/[[:space:]]+$/, "", trimmed)     # buang spasi/tab di akhir

    if (trimmed == "") { kosong++; next } # skip baris kosong

    if (trimmed ~ /,$/) {
      printf "BARIS %d: trailing comma\n  -> %s\n", NR, line
      bad++
    }
  }
  END {
    if (bad > 0) {
      printf "\nTotal baris berkoma di akhir: %d\n", bad
      printf "Baris kosong (diabaikan): %d\n", kosong
      exit 2
    } else {
      printf "OK: tidak ada koma di akhir baris (kosong: %d)\n", kosong
    }
  }
' "$FILE"
