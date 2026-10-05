#!/bin/bash
# (c) J~Net 2026
#
# ./piper-start.sh
#

PIPER_PYTHON="/home/jay/Documents/Apps/ai-voice-chat/piper-venv/bin/python"
PIPER_MODEL="/home/jay/Documents/Apps/ai-voice-chat/voices/en_GB-alba-medium.onnx"
PIPER_PORT=5000

if [ ! -x "$PIPER_PYTHON" ]; then
    echo "ERROR: Piper Python not found:"
    echo "$PIPER_PYTHON"
    exit 1
fi

if ! "$PIPER_PYTHON" -c "import flask" >/dev/null 2>&1; then
    echo "Flask is not installed. Installing it..."
    "$PIPER_PYTHON" -m pip install Flask
/home/jay/Documents/Apps/ai-voice-chat/piper-venv/bin/python -m pip install fastapi uvicorn
    if [ $? -ne 0 ]; then
        echo "ERROR: Failed to install Flask."
        exit 1
    fi
fi

/home/$USER/Documents/Apps/ai-voice-chat/piper-venv/bin/python -m pip install fastapi uvicorn

echo "Starting Piper HTTP server..."
echo "Endpoint: http://0.0.0.0:$PIPER_PORT"
echo "Voice: $PIPER_MODEL"
echo

exec "$PIPER_PYTHON" -m piper.http_server \
    --model "$PIPER_MODEL" \
    --host 0.0.0.0 \
    --port "$PIPER_PORT"
