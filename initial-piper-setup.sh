#!/bin/bash
# (c) J~Net 2026
#
# ./setup-piper-voice.sh
#

set -e

PIPER_DIR="$HOME/piper"
VOICE_DIR="$PIPER_DIR/voices"
VOICE="en_US-lessac-medium"
BASE_URL="https://huggingface.co/rhasspy/piper-voices/resolve/main/en/en_US/lessac/medium"

echo
echo "===== PIPER TTS VOICE SETUP ====="
echo
echo "Piper directory: $PIPER_DIR"
echo "Voice: $VOICE"
echo

mkdir -p "$VOICE_DIR"

if command -v piper >/dev/null 2>&1; then
PIPER_BIN="$(command -v piper)"
elif [ -x "$PIPER_DIR/piper" ]; then
PIPER_BIN="$PIPER_DIR/piper"
else
echo "Piper was not found."
echo
echo "Install Piper with:"
echo "  python3 -m pip install piper-tts"
echo
exit 1
fi

echo "Piper found: $PIPER_BIN"
echo

MODEL="$VOICE_DIR/$VOICE.onnx"
CONFIG="$VOICE_DIR/$VOICE.onnx.json"

if [ ! -f "$MODEL" ]; then
echo "Downloading $VOICE model..."
curl -L --fail --progress-bar 
-o "$MODEL" 
"$BASE_URL/$VOICE.onnx"
else
echo "Model already exists."
fi

if [ ! -f "$CONFIG" ]; then
echo "Downloading $VOICE configuration..."
curl -L --fail --progress-bar 
-o "$CONFIG" 
"$BASE_URL/$VOICE.onnx.json"
else
echo "Voice configuration already exists."
fi

echo
echo "===== TESTING PIPER ====="
echo

TEST_WAV="/tmp/piper-$VOICE-test.wav"

echo "This is Piper text to speech using the Lessac English voice." 
| "$PIPER_BIN" 
--model "$MODEL" 
--output_file "$TEST_WAV"

echo
echo "Voice installed successfully:"
echo "  $MODEL"
echo
echo "Test audio:"
echo "  $TEST_WAV"
echo

if command -v paplay >/dev/null 2>&1; then
paplay "$TEST_WAV"
elif command -v aplay >/dev/null 2>&1; then
aplay "$TEST_WAV"
else
echo "No paplay/aplay found, so the WAV was not played."
fi

echo
echo "===== COMPLETE ====="
echo
echo "Piper voice: $VOICE"
echo "Model: $MODEL"
echo

