#!/bin/bash
# Records every tile from the real package widgets and writes them to ../../tiles.
# Needs macOS (it borrows the system San Francisco font), Flutter, ffmpeg and
# img2webp (brew install ffmpeg webp).
set -euo pipefail
cd "$(dirname "$0")"
OUT=../../tiles
RAW=build/raw
mkdir -p "$RAW" "$OUT" build/frames
flutter pub get >/dev/null
TILE_OUT="$PWD/$RAW" FLUTTER_ROOT="$(dirname "$(dirname "$(command -v flutter)")")" \
  flutter test test/tiles_test.dart

for json in "$RAW"/*.json; do
  n=$(basename "$json" .json)
  read -r w h f < <(python3 -c "import json;d=json.load(open('$json'));print(d['w'],d['h'],d['frames'])")
  src=(-f rawvideo -pix_fmt rgba -s "${w}x${h}" -r 25 -i "$RAW/$n.rgba")
  if [ "$f" -le 2 ]; then
    # A still: one PNG.
    ffmpeg -v error -y "${src[@]}" -frames:v 1 -vf "scale=480:480:flags=lanczos" "$OUT/$n.png"
  elif [ "$n" = yako_celebrations ]; then
    # Particles make a huge GIF, so this one is an animated WebP.
    rm -f build/frames/*
    ffmpeg -v error -y "${src[@]}" -vf "fps=20,scale=480:480:flags=lanczos" build/frames/f%03d.png
    img2webp -loop 0 -mixed -min_size -lossy -q 50 -m 6 -d 50 build/frames/f*.png -o "$OUT/$n.webp"
  else
    ffmpeg -v error -y "${src[@]}" -vf "fps=20,scale=480:480:flags=lanczos,split[a][b];[a]palettegen=max_colors=128:stats_mode=diff[p];[b][p]paletteuse=dither=sierra2_4a:diff_mode=rectangle" -loop 0 "$OUT/$n.gif"
  fi
  echo "tile: $n"
done
rm -rf build
