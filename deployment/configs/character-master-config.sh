#!/bin/bash
# Character Master Workflow Configuration
# This configuration file defines all models and nodes needed for the Character Master workflow
# It uses Qwen models for image generation/editing and Flux models for enhanced capabilities

# APT packages (if any system packages are needed)
APT_PACKAGES=(
)

# Python packages (additional pip packages if needed)
PIP_PACKAGES=(
)

# Custom nodes required for this workflow
NODES=(
    "https://github.com/kijai/ComfyUI-KJNodes"
    "https://github.com/kijai/ComfyUI-Florence2"
    "https://github.com/ssitu/ComfyUI_UltimateSDUpscale"
    "https://github.com/cubiq/ComfyUI_essentials"
)

# Diffusion Models (UNet) - Qwen Image models
DIFFUSION_MODELS=(
    "https://huggingface.co/Comfy-Org/Qwen-Image-Edit_ComfyUI/resolve/main/split_files/diffusion_models/qwen_image_edit_fp8_e4m3fn.safetensors"
    "https://huggingface.co/lightx2v/Qwen-Image-Lightning/resolve/main/Qwen-Image-Lightning-4steps-V1.0.safetensors"
    "https://huggingface.co/lightx2v/Qwen-Image-Lightning/resolve/main/Qwen-Image-Edit-2509/Qwen-Image-Edit-2509-Lightning-4steps-V1.0-bf16.safetensors"
    "https://huggingface.co/Comfy-Org/Qwen-Image-Edit_ComfyUI/resolve/main/split_files/diffusion_models/qwen_image_edit_2509_fp8_e4m3fn.safetensors"
    "https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/diffusion_models/qwen_image_fp8_e4m3fn.safetensors"
)

# Text Encoders - Qwen text encoder
TEXT_ENCODER_MODELS=(
    "https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/text_encoders/qwen_2.5_vl_7b_fp8_scaled.safetensors"
)

# VAE Models - Qwen and Flux VAE
VAE_MODELS=(
    "https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/vae/qwen_image_vae.safetensors"
    "https://huggingface.co/black-forest-labs/FLUX.1-schnell/resolve/main/ae.safetensors"
)

# ControlNet Models - Qwen ControlNet Union
CONTROLNET_MODELS=(
    "https://huggingface.co/InstantX/Qwen-Image-ControlNet-Union/resolve/main/diffusion_pytorch_model.safetensors"
)

# Upscale Models - Real-ESRGAN
UPSCALE_MODELS=(
    "https://huggingface.co/Comfy-Org/Real-ESRGAN_repackaged/resolve/main/RealESRGAN_x4plus.safetensors"
)

# Checkpoint Models - Flux Dev (all-in-one model from Comfy-Org)
CHECKPOINT_MODELS=(
    "https://huggingface.co/Comfy-Org/flux1-dev/resolve/main/flux1-dev-fp8.safetensors"
)

# CLIP Models - Not needed with all-in-one Flux model
CLIP_MODELS=(
)

# Additional configuration options
AUTO_UPDATE=${AUTO_UPDATE:-true}
