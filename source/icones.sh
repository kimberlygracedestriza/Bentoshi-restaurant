#!/usr/bin/env bash
# Make Lordicon animated webp icons transparent: white bg -> alpha, navy lines -> white, red kept.
# Usage: bash icones.sh <input.webp> <output.webp> [size=240]
set -euo pipefail
export PATH="/opt/homebrew/bin:$PATH"
IN="$1"; OUT="$2"; SIZE="${3:-240}"
T=$(mktemp -d)
N=$(webpmux -info "$IN" | awk '/Number of frames/ {print $4}')
D=$(webpmux -info "$IN" | awk '$1=="1:" {print $7}')
for i in $(seq 1 "$N"); do
  f=$(printf "%04d" "$i")
  webpmux -get frame "$i" "$IN" -o "$T/r_$f.webp" >/dev/null
  dwebp -quiet "$T/r_$f.webp" -o "$T/r_$f.png"
done
RED='gt(r(X,Y)-g(X,Y),60)'
ffmpeg -v error -y -i "$T/r_%04d.png" -vf "format=rgba,geq=r='if($RED,r(X,Y),255)':g='if($RED,g(X,Y),255)':b='if($RED,b(X,Y),255)':a='clip((255-min(min(r(X,Y),g(X,Y)),b(X,Y)))*1.15,0,255)',scale=$SIZE:$SIZE:flags=lanczos" "$T/o_%04d.png"
img2webp -loop 0 -lossy -q 70 -d "$D" "$T"/o_*.png -o "$OUT" >/dev/null 2>&1
rm -rf "$T"
echo "OK $OUT ($N frames, ${D}ms) $(du -h "$OUT" | cut -f1)"
