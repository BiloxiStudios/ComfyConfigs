#!/bin/bash
set -e

cd /workspace/ComfyUI/models

# Diffusion models (UNet)
mkdir -p diffusion_models
cd diffusion_models
wget -q --show-progress -N "https://huggingface.co/Comfy-Org/Qwen-Image-Edit_ComfyUI/resolve/main/split_files/diffusion_models/qwen_image_edit_fp8_e4m3fn.safetensors"
wget -q --show-progress -N "https://huggingface.co/lightx2v/Qwen-Image-Lightning/resolve/main/Qwen-Image-Lightning-4steps-V1.0.safetensors"
wget -q --show-progress -N "https://huggingface.co/lightx2v/Qwen-Image-Lightning/resolve/main/Qwen-Image-Edit-2509/Qwen-Image-Edit-2509-Lightning-4steps-V1.0-bf16.safetensors"
wget -q --show-progress -N "https://huggingface.co/Comfy-Org/Qwen-Image-Edit_ComfyUI/resolve/main/split_files/diffusion_models/qwen_image_edit_2509_fp8_e4m3fn.safetensors"
wget -q --show-progress -N "https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/diffusion_models/qwen_image_fp8_e4m3fn.safetensors"

# Text encoder (Qwen)
mkdir -p ../text_encoders && cd ../text_encoders
wget -q --show-progress -N "https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/text_encoders/qwen_2.5_vl_7b_fp8_scaled.safetensors"

# VAE (Qwen + Flux)
mkdir -p ../vae && cd ../vae
wget -q --show-progress -N "https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/vae/qwen_image_vae.safetensors"
wget -q --show-progress -N -O ae.safetensors "https://huggingface.co/black-forest-labs/FLUX.1-schnell/resolve/main/ae.safetensors"

# ControlNet
mkdir -p ../controlnet && cd ../controlnet
wget -q --show-progress -N -O Qwen-Image-InstantX-ControlNet-Union.safetensors "https://huggingface.co/InstantX/Qwen-Image-ControlNet-Union/resolve/main/diffusion_pytorch_model.safetensors"

# Upscalers
mkdir -p ../upscale_models && cd ../upscale_models
wget -q --show-progress -N "https://huggingface.co/Comfy-Org/Real-ESRGAN_repackaged/resolve/main/RealESRGAN_x4plus.safetensors"

# Flux checkpoint
mkdir -p ../checkpoints && cd ../checkpoints
wget -q --show-progress -N "https://huggingface.co/Kijai/flux-fp8/resolve/main/flux1-dev-fp8.safetensors"

# Flux CLIP/text encoders
mkdir -p ../clip && cd ../clip
wget -q --show-progress -N "https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/clip_l.safetensors"
wget -q --show-progress -N "https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/t5xxl_fp8_e4m3fn.safetensors"

# Custom nodes
cd /workspace/ComfyUI/custom_nodes

[ ! -d "ComfyUI-KJNodes" ] && git clone https://github.com/kijai/ComfyUI-KJNodes.git && cd ComfyUI-KJNodes && pip install -r requirements.txt && cd ..
[ ! -d "ComfyUI-Florence2" ] && git clone https://github.com/kijai/ComfyUI-Florence2.git && cd ComfyUI-Florence2 && pip install -r requirements.txt && cd ..
[ ! -d "ComfyUI_UltimateSDUpscale" ] && git clone --recursive https://github.com/ssitu/ComfyUI_UltimateSDUpscale.git
[ ! -d "ComfyUI_essentials" ] && git clone https://github.com/cubiq/ComfyUI_essentials.git && cd ComfyUI_essentials && pip install -r requirements.txt && cd ..

echo "All models + custom nodes + RealESRGAN_x4plus upscaler installed."
