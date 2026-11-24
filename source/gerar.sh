#!/usr/bin/env bash
# Bentoshi media generation (paid, OpenRouter). Est. $2.55 first pass.
# Usage: bash gerar.sh keyframe | video | images
set -euo pipefail
S=~/.claude/skills/site-cinematografico/scripts
P=~/sites/Bentoshi
STYLE="STYLE: warm, precise, welcoming, cinematic still, 50mm lens, low-key chiaroscuro with a soft overhead key light, color palette #181a27, #d6282e, film grain, shallow depth of field, editorial food photography, no text, no letters, no logo, no watermark, no frame, no border."
BG="seamless deep navy black (#181a27) background, the edges of the frame dissolve into pure deep navy black, no horizon line, no walls, no floor edge"

img() { python3 -I $S/or_image.py --aspect 16:9 --resolucao 2K --saida "$P/source/$1.png" --prompt "$2 $STYLE"; }

case "${1:-}" in
  keyframe)
    img quadro-chave "Extreme close-up macro shot of a single piece of glossy tuna nigiri resting on a dark slate board, placed in the center third, individual rice grains visible and glistening, a faint wisp of steam, a small sliver of red chili beside it, generous negative space, background falls off into deep navy black (#181a27). Japanese restaurant at night, polished black lacquer and dark stone." ;;
  video)
    python3 -I $S/or_video.py --duracao 8 --resolucao 1080p --aspect 16:9 \
      --primeiro-quadro "$P/source/quadro-chave.png" --saida "$P/source/abertura.mp4" \
      --prompt "Single continuous shot, no cuts. The camera performs a slow crane up and pull back from a macro of a tuna nigiri. First third: glossy rice grains and tuna in sharp macro, faint steam. Middle: the camera rises to reveal a full sushi and bento platter on dark slate, red accents of chili and maguro. Final third: the camera settles in a top-down view of a table set for a family, several bento boxes, chopsticks and small dishes, warm light. Smooth, steady, cinematic motion, constant speed, no camera shake, no text, no logos, no people. Lighting stays consistent. $STYLE" ;;
  images)
    img menu "A generous sushi platter with nigiri and maki on a dark slate board, isolated, emerging from a $BG, subject placed on the left, lots of empty navy space on the right, warm rim light."
    img story "A wooden hangiri rice tub filled with pearly white steaming sushi rice and a wooden paddle, beside a Japanese chef knife with a plain unmarked polished blade, isolated, emerging from a $BG, subject placed on the right, lots of empty navy space on the left, warm rim light."
    img philosophy "Out of focus, atmospheric Japanese restaurant interior at night, soft glowing paper lanterns and a few red accents, central composition, diffuse bokeh, fades into a $BG."
    img promo "A black lacquer bento box with sushi, tamagoyaki and pickled ginger, isolated, emerging from a $BG, subject placed on the right, lots of empty navy space on the left, warm rim light."
    img reviews "Out of focus, atmospheric wide view of a warm Japanese dining room with wooden tables and soft lantern light, central composition, diffuse bokeh, fades into a $BG."
    img reserve "Out of focus, atmospheric table setting with chopsticks on a ceramic rest, a small teacup and folded napkin, central composition, diffuse bokeh, fades into a $BG." ;;
  story)
    img story "A wooden hangiri rice tub filled with pearly white steaming sushi rice and a wooden paddle, beside a Japanese chef knife with a plain unmarked polished blade, isolated, emerging from a $BG, subject placed on the right, lots of empty navy space on the left, warm rim light." ;;
  *) echo "Usage: bash gerar.sh keyframe | video | images" ;;
esac
