#!/bin/bash
# (c) J~Net 2026
#
# ./start.sh
#
#


/home/jay/Documents/Apps/ai-voice-chat/piper-venv/bin/python -m piper.http_server \
    --model /home/jay/Documents/Apps/ai-voice-chat/voices/en_GB-alba-medium.onnx \
    --host 0.0.0.0 \
    --port 5000



