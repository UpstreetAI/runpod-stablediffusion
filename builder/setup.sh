mv /src/builder/clone.sh /clone.sh
chmod +x /clone.sh

/clone.sh taming-transformers https://github.com/CompVis/taming-transformers.git 24268930bf1dce879235a7fddd0b2355b84d7ea6 && \
    rm -rf data assets **/*.ipynb

/clone.sh stable-diffusion-stability-ai https://github.com/Stability-AI/stablediffusion.git 47b6b607fdd31875c9279cd2f4f16b92e4ea958e && \
    rm -rf assets data/**/*.png data/**/*.jpg data/**/*.gif

/clone.sh stable-diffusion-stability-ai https://github.com/Stability-AI/stablediffusion.git 47b6b607fdd31875c9279cd2f4f16b92e4ea958e && \
    rm -rf assets data/**/*.png data/**/*.jpg data/**/*.gif

/clone.sh CodeFormer https://github.com/sczhou/CodeFormer.git c5b4593074ba6214284d6acd5f1719b6c5d739af && \
    rm -rf assets inputs


/clone.sh BLIP https://github.com/salesforce/BLIP.git 48211a1594f1321b00f14c9f7a5b4813144b2fb9 && \
/clone.sh k-diffusion https://github.com/crowsonkb/k-diffusion.git 5b3af030dd83e0297272d861c19477735d0317ec && \
/clone.sh clip-interrogator https://github.com/pharmapsychotic/clip-interrogator 2486589f24165c8e3b303f84e9dbbea318df83e8 && \
/clone.sh generative-models https://github.com/Stability-AI/generative-models 45c443b316737a4ab6e40413d7794a7f5657c19f


SHA="5ef669de080814067961f28357256e8fe27544f4"

DEBIAN_FRONTEND=noninteractive \
    PIP_PREFER_BINARY=1 \
    LD_PRELOAD=libtcmalloc.so \
    ROOT=/src/stable-diffusion-webui \
    PYTHONUNBUFFERED=1


export COMMANDLINE_ARGS="--skip-torch-cuda-test --precision full --no-half"
export TORCH_COMMAND='pip install --pre torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/nightly/rocm5.6'


# mkdir -p /src/stable-diffusion-webui

apt-get update && \
    apt install -y \
    fonts-dejavu-core rsync git jq moreutils aria2 wget libgoogle-perftools-dev procps libgl1 libglib2.0-0 && \
    apt-get autoremove -y && rm -rf /var/lib/apt/lists/* && apt-get clean -y


cd /src

git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git && \
    cd stable-diffusion-webui && \
    git reset --hard ${SHA}

mv /repositories ${ROOT}


mkdir ${ROOT}/interrogate && cp ${ROOT}/repositories/clip-interrogator/data/* ${ROOT}/interrogate

pip install -r ${ROOT}/repositories/CodeFormer/requirements.txt

cp /src/builder/requirements.txt /requirements.txt

pip install --upgrade pip && \
    pip install --upgrade -r /requirements.txt --no-cache-dir && \
    rm /requirements.txt

cp /src/builder/cache.py ${ROOT}/cache.py


git clone https://github.com/light-and-ray/sd-webui-lcm-sampler ${ROOT}/extensions/sd-webui-lcm-sampler
git clone https://github.com/continue-revolution/sd-webui-animatediff ${ROOT}/extensions/sd-webui-animatediff
mkdir -p ${ROOT}/models/Lora
wget https://civitai.com/api/download/models/80635
mv '80635' ${ROOT}/models/Stable-diffusion/niji.safetensors
wget https://civitai.com/api/download/models/179257
mv '179257' ${ROOT}/models/Lora/gameiconlora.safetensors
wget https://civitai.com/api/download/models/96318
mv '96318' ${ROOT}/models/Lora/niji3d.safetensors
mv ${ROOT}/models/Stable-diffusion/niji.safetensors ${ROOT}/models/Stable-diffusion/model.safetensors


cp /src/builder/cache.py ${ROOT}
python /src/builder/cache.py --use-cpu=all --ckpt ${ROOT}/models/Stable-diffusion/model.safetensors

apt-get autoremove -y && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*

# mv /src/src/start.sh /src/start.sh

# chmod +x /src/start.sh