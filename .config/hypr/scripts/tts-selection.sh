#!/usr/bin/env bash
# Reads the selected text (primary selection) aloud with Piper.
# Running it again while it speaks stops it
# set -u

voice=${TTS_VOICE:-$HOME/.local/share/piper/en_US-lessac-medium.onnx}
speed=${TTS_SPEED:-1.0} # Piper's length_scale: below 1 is faster
pidfile=${XDG_RUNTIME_DIR:-/tmp}/tts-selection.pid

# Already speaking: stop the whole pipeline (its process group) and exit
if [[ -f $pidfile ]] && kill -0 -- "-$(<"$pidfile")" 2>/dev/null; then
  kill -- "-$(<"$pidfile")"
  rm -f "$pidfile"
  exit
fi

text=$(wl-paste --primary --no-newline 2>/dev/null)
[[ -n ${text//[[:space:]]/} ]] || exit 0

rate=$(grep -o '"sample_rate": *[0-9]*' "$voice.json" | grep -o '[0-9]*$')

# Joins lines so wrapped text isn't read with a pause at every line break
setsid bash -c '
  tr "\n" " " | piper-tts -q -m "$1" --length_scale "$2" --output_raw |
    pw-play --raw --rate "$3" --channels 1 --format s16 -
  rm -f "$4"
' _ "$voice" "$speed" "${rate:-22050}" "$pidfile" <<<"$text" >/dev/null 2>&1 &
echo $! >"$pidfile"
