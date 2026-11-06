#!/bin/bash
# rename-to-number.sh
# Ubah semua file .txt di folder menjadi 001.txt, 002.txt, 003.txt, ...

DIR="${1:-text/ID}"

# Cek folder
if [ ! -d "$DIR" ]; then
    echo "❌ Folder '$DIR' tidak ditemukan."
    exit 1
fi

cd "$DIR" || exit 1

# Hitung file
mapfile -t files < <(find . -maxdepth 1 -type f -name "*.txt" | sort)
count=${#files[@]}

if [ "$count" -eq 0 ]; then
    echo "⚠️  Tidak ada file .txt di '$DIR'."
    exit 0
fi

echo "📁 Folder : $DIR"
echo "📄 Jumlah : $count file .txt"
echo ""

# Preview
echo "Preview perubahan:"
i=1
for f in "${files[@]}"; do
    f="${f#./}"
    printf "  %-42s ➜  %03d.txt\n" "$f" "$i"
    i=$((i+1))
done

echo ""
read -r -p "Lanjutkan rename? (y/n): " confirm
if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
    echo "🚫 Dibatalkan."
    exit 0
fi

# Step 1: rename ke nama temporary (biar tidak bentrok)
TMP_PREFIX="__tmp_rename_$$_"
i=1
for f in "${files[@]}"; do
    f="${f#./}"
    mv -- "$f" "${TMP_PREFIX}${i}.txt"
    i=$((i+1))
done

# Step 2: rename dari temporary ke nama final
i=1
for f in ${TMP_PREFIX}*.txt; do
    [ -e "$f" ] || continue
    newname=$(printf "%03d.txt" "$i")
    mv -- "$f" "$newname"
    i=$((i+1))
done

echo ""
echo "✅ Selesai! $((i-1)) file berhasil di-rename."
