#!/bin/bash

echo "Worker Initiated"
ROOT=/src/stable-diffusion-webui
echo "Starting WebUI API"
cd /src/stable-diffusion-webui/
ls -l


cp /src/builder/cache.py ${ROOT}
python ${ROOT}/cache.py --use-cpu=all --ckpt ${ROOT}/models/Stable-diffusion/model.safetensors

python /src/stable-diffusion-webui/webui.py --skip-python-version-check --skip-torch-cuda-test --skip-install --ckpt /model.safetensors --lowram --opt-sdp-attention --disable-safe-unpickle --port 3000 --api --nowebui --skip-version-check  --no-hashing --no-download-sd-model &

# echo "Starting RunPod Handler"
# python -u /rp_handler.py
