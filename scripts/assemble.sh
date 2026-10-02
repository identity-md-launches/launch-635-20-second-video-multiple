#!/usr/bin/env bash
# Assemble artifacts/video.mp4 from the three generated source clips.
# Expects c1.mp4, c2.mp4, c3.mp4 (8 s each, 1920x1080, 24 fps, AAC) in $SRC.
# Run from the repository root. Prefix ffmpeg with `imd-media` where required.
set -euo pipefail
SRC=${SRC:-test/scratch}
FFMPEG=${FFMPEG:-ffmpeg}
mkdir -p artifacts

# Shot 1: saturation ramps from 0 (black and white) to full color over ~4 s.
# Shot 3: only its first 6 s are used; it is cropped to remove a black band the
#         model left along the bottom edge, then scaled back to 1920x1080.
# Shots are joined with 1 s crossfades: 8 + 8 + 6 - 1 - 1 = 20 s.
$FFMPEG -v error -y -i "$SRC/c1.mp4" -i "$SRC/c2.mp4" -i "$SRC/c3.mp4" -filter_complex "\
[0:v]hue=s='min(1,max(0,(t-0.8)/4))',fps=24,settb=1/24,format=yuv420p[v0];\
[1:v]fps=24,settb=1/24,format=yuv420p[v1];\
[2:v]trim=0:6,setpts=PTS-STARTPTS,crop=1692:952:114:0,scale=1920:1080:flags=lanczos,setsar=1,fps=24,settb=1/24,format=yuv420p[v2];\
[v0][v1]xfade=transition=fade:duration=1:offset=7[x1];\
[x1][v2]xfade=transition=fade:duration=1:offset=14,fade=t=in:st=0:d=0.6,fade=t=out:st=19:d=1[v];\
[2:a]atrim=0:6,asetpts=PTS-STARTPTS[a2];\
[0:a][1:a]acrossfade=d=1[ax];[ax][a2]acrossfade=d=1,afade=t=in:st=0:d=0.6,afade=t=out:st=19:d=1,atrim=0:20[a]" \
  -map "[v]" -map "[a]" -t 20 \
  -c:v libx264 -preset slow -crf 22 -maxrate 10M -bufsize 20M -pix_fmt yuv420p -profile:v high \
  -c:a aac -b:a 192k -ar 48000 -movflags +faststart artifacts/video.mp4
