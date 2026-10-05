#!/usr/bin/env python3
# (c) J~Net 2026

import io
import asyncio
import wave
from pathlib import Path

from fastapi import FastAPI,HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import Response
from pydantic import BaseModel
from piper import PiperVoice

HOST="0.0.0.0"
PORT=5000

MODEL_PATH=Path(
    "/home/jay/Documents/Apps/ai-voice-chat/voices/en_GB-alba-medium.onnx"
)

app=FastAPI(title="J~Net Piper OpenAI TTS")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=False,
    allow_methods=["*"],
    allow_headers=["*"]
)

print(f"Loading Piper voice: {MODEL_PATH}")

voice=PiperVoice.load(str(MODEL_PATH))

print("Piper voice loaded.")


class SpeechRequest(BaseModel):
    model:str="piper"
    input:str
    voice:str="en_GB-alba-medium"
    response_format:str="wav"
    speed:float=1.0


@app.get("/")
async def root():
    return {
        "service":"J~Net Piper OpenAI TTS",
        "endpoint":"/audio/speech",
        "openai_endpoint":"/v1/audio/speech",
        "model":"piper",
        "voice":"en_GB-alba-medium"
    }


@app.get("/v1/models")
async def models():
    return {
        "object":"list",
        "data":[
            {
                "id":"piper",
                "object":"model",
                "owned_by":"J~Net"
            }
        ]
    }


@app.get("/models")
async def models_compat():
    return {
        "object":"list",
        "data":[
            {
                "id":"piper",
                "object":"model",
                "owned_by":"J~Net"
            }
        ]
    }


async def generate_speech(request:SpeechRequest):
    if not request.input.strip():
        raise HTTPException(
            status_code=400,
            detail="input cannot be empty"
        )

    if request.response_format not in ["wav","pcm"]:
        raise HTTPException(
            status_code=400,
            detail="Only wav and pcm are currently supported"
        )

    if request.speed<=0:
        raise HTTPException(
            status_code=400,
            detail="speed must be greater than 0"
        )

    output=io.BytesIO()

    loop=asyncio.get_running_loop()

    def synthesize():
        with wave.open(output,"wb") as wav_file:
            voice.synthesize_wav(
                request.input,
                wav_file
            )

    await loop.run_in_executor(None,synthesize)

    audio=output.getvalue()

    if not audio:
        raise HTTPException(
            status_code=500,
            detail="Piper returned no audio"
        )

    if request.response_format=="pcm":
        with wave.open(io.BytesIO(audio),"rb") as wav_file:
            pcm=wav_file.readframes(
                wav_file.getnframes()
            )

            sample_rate=wav_file.getframerate()

        return Response(
            content=pcm,
            media_type="audio/pcm",
            headers={
                "X-Audio-Sample-Rate":str(sample_rate)
            }
        )

    return Response(
        content=audio,
        media_type="audio/wav"
    )


@app.post("/v1/audio/speech")
async def speech_v1(request:SpeechRequest):
    return await generate_speech(request)


@app.post("/audio/speech")
async def speech_compat(request:SpeechRequest):
    return await generate_speech(request)


if __name__=="__main__":
    import uvicorn

    uvicorn.run(
        app,
        host=HOST,
        port=PORT
    )
