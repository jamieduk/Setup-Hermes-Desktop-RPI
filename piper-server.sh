#!/bin/bash
# (c) J~Net 2026
#
# ./piper-start.sh
#

PIPER_PYTHON="/home/jay/Documents/Apps/ai-voice-chat/piper-venv/bin/python"
SERVER="/home/jay/Downloads/Hermes-Desktop/piper-openai-server.py"

if [ ! -x "$PIPER_PYTHON" ]; then
    echo "ERROR: Piper Python not found:"
    echo "$PIPER_PYTHON"
    exit 1
fi

if [ ! -f "$SERVER" ]; then
    echo "ERROR: OpenAI Piper server not found:"
    echo "$SERVER"
    exit 1
fi

echo "========================================"
echo " J~Net Piper OpenAI TTS"
echo "========================================"
echo
echo "Endpoint:"
echo "http://127.0.0.1:5000/v1/audio/speech"
echo
echo "Model: piper"
echo "Voice: en_GB-alba-medium"
echo

exec "$PIPER_PYTHON" "$SERVER"
