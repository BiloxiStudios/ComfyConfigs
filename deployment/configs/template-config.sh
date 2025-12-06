#!/bin/bash
# Template Workflow Configuration
# Copy this file and customize it for your workflow:
#   cp configs/template-config.sh configs/my-workflow-config.sh

# APT packages (system packages required by your workflow)
APT_PACKAGES=(
    #"example-package"
)

# Python packages (pip packages required by your workflow)
PIP_PACKAGES=(
    #"numpy"
    #"pillow"
)

# Custom nodes (GitHub repositories)
NODES=(
    #"https://github.com/ltdrdata/ComfyUI-Manager"
    #"https://github.com/cubiq/ComfyUI_essentials"
)

# Diffusion Models (UNet models)
DIFFUSION_MODELS=(
    #"https://huggingface.co/user/model/resolve/main/model.safetensors"
)

# Text Encoders
TEXT_ENCODER_MODELS=(
    #"https://huggingface.co/user/model/resolve/main/text_encoder.safetensors"
)

# VAE Models
VAE_MODELS=(
    #"https://huggingface.co/user/model/resolve/main/vae.safetensors"
)

# ControlNet Models
CONTROLNET_MODELS=(
    #"https://huggingface.co/user/model/resolve/main/controlnet.safetensors"
)

# Upscale Models
UPSCALE_MODELS=(
    #"https://huggingface.co/user/model/resolve/main/upscaler.safetensors"
)

# Checkpoint Models
CHECKPOINT_MODELS=(
    #"https://huggingface.co/user/model/resolve/main/checkpoint.safetensors"
)

# CLIP Models
CLIP_MODELS=(
    #"https://huggingface.co/user/model/resolve/main/clip.safetensors"
)

# LoRA Models
LORA_MODELS=(
    #"https://huggingface.co/user/model/resolve/main/lora.safetensors"
)

# Configuration options
AUTO_UPDATE=${AUTO_UPDATE:-true}  # Set to false to disable auto-updates of nodes
