# Regeneration: frogs, dragonflies, and the mother swarm

A 20-second video. Pepe-style frogs in field-worker clothes plant trees in a barren field. A swarm of dragonflies directs them, and a mother dragonfly wired into AI infrastructure orchestrates the swarm. The black-and-white land turns to color as it regenerates. There is no on-screen text.

**Output:** `artifacts/video.mp4` (`video/mp4`). The daemon delivers it separately, so it is not committed.

## Specs (measured with ffprobe)

| Property   | Value |
|------------|-------|
| Duration   | 20.000 s |
| Dimensions | 1920 × 1080 (16:9), 24 fps |
| Video      | H.264 High profile, yuv420p, about 10 Mb/s (CRF 22, 10 Mb/s cap) |
| Audio      | AAC-LC, 48 kHz, stereo, 192 kb/s (mean −21.8 dB, peak −0.6 dB) |
| Container  | MP4 with `moov` at the front (`+faststart`), so it plays in a browser |
| Size       | about 26.2 MB |

## Storyboard

| Time      | Shot |
|-----------|------|
| 0–8 s     | A barren, cracked field. Frogs in overalls, plaid shirts, and straw hats dig and plant saplings while dragonflies hover overhead. The frame starts fully desaturated, and color rises over the first ~5 s: the sky turns blue and grass rings spread around each sapling. |
| 7–15 s    | A giant glowing mother dragonfly with fiber-optic strands runs down to a row of server racks and cooling towers. She releases the swarm, and a wave of color sweeps the grey field green while frogs plant rows of trees. |
| 14–20 s   | The land is fully regenerated: a young forest, a meadow, and a stream. Frogs lean on their shovels while the swarm spirals up toward the mother dragonfly. The clip fades to black. |

Shots are joined with 1 s crossfades. There is a 0.6 s fade-in and a 1 s fade-out, with matching audio fades.

## Audio

The audio is the ambient sound generated with each shot: wind, digging, buzzing wings, an electrical hum during the data-center shot, and birdsong at the end. Each shot's audio is crossfaded with the video. There is no music, narration, or dialogue.

## How it was made

1. I generated three 8-second clips with `google/veo-3-fast` on Replicate (text-to-video, 16:9, audio on). The prompts asked for no text, captions, or logos.
   Prediction IDs: `vxswsv8bqsrmw0d0zsdbs116h0`, `495dahs9m5rmy0d0zsd85exwpg`, `sssvwvhpp5rmy0d0zsd9t0dvg0`.
2. I assembled the clips with ffmpeg using `scripts/assemble.sh`.
   - It adds a saturation ramp so the opening starts in true black and white.
   - It uses only the first 6 s of shot 3, cropped and rescaled to remove a black band the model left along the bottom edge.
   - It encodes to H.264 + AAC with faststart.

The source clips are not committed (~115 MB at the generator's high bitrate). To rebuild, put them in `test/scratch/` as `c1.mp4`, `c2.mp4`, and `c3.mp4`, then run the script.

## Limitations

- The frogs are AI-generated, Pepe-*style* characters, not an exact reproduction. Their look varies between shots, and some are frogs sitting or crouching rather than all wearing full work clothes.
- The color change is partly done by the model and partly a global saturation ramp added in shot 1. It is not a precise per-tree mask. Shot 2 starts half grey and half color by design.
- Shot 3 is cropped by about 12% and upscaled, so it is slightly softer than shots 1–2. A few corner leaves from the original frame edge remain.
- The "mother dragonfly connected to AI infrastructure" is shown visually: glowing cables run from her body to server racks. It is not explained, which follows the no-words requirement.
- There may be generative artifacts: overlapping or semi-transparent frogs, and dragonflies that blur or merge in fast motion.
- I checked the structure with ffprobe and reviewed frames on contact sheets (one frame every 2 s of the final cut, plus per-shot sheets); no on-screen text was found. I did not watch every frame for quality.
