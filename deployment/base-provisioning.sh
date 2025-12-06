#!/bin/bash
# Base ComfyUI Provisioning Script
# Based on Vast.ai default provisioning with enhancements
# This script provides the core provisioning functionality and can be used
# with workflow-specific configuration files

set -e

# Deactivate conda if active to prevent conflicts
if command -v conda &> /dev/null; then
    conda deactivate 2>/dev/null || true
fi

# Detect if running in Vast.ai environment or local
if [[ -f /venv/main/bin/activate ]]; then
    source /venv/main/bin/activate
fi

# Set ComfyUI directory
COMFYUI_DIR=${WORKSPACE:-/workspace}/ComfyUI

# Default arrays - these can be overridden by sourcing a config file
APT_PACKAGES=(
    #"package-1"
    #"package-2"
)

PIP_PACKAGES=(
    #"package-1"
    #"package-2"
)

NODES=(
    #"https://github.com/ltdrdata/ComfyUI-Manager"
    #"https://github.com/cubiq/ComfyUI_essentials"
)

WORKFLOWS=(

)

CHECKPOINT_MODELS=(
)

UNET_MODELS=(
)

DIFFUSION_MODELS=(
)

LORA_MODELS=(
)

VAE_MODELS=(
)

ESRGAN_MODELS=(
)

UPSCALE_MODELS=(
)

CONTROLNET_MODELS=(
)

TEXT_ENCODER_MODELS=(
)

CLIP_MODELS=(
)

### PROVISIONING FUNCTIONS ###

function provisioning_start() {
    provisioning_print_header
    provisioning_get_apt_packages
    provisioning_get_nodes
    provisioning_get_pip_packages

    # Download models to their respective directories
    provisioning_get_files \
        "${COMFYUI_DIR}/models/checkpoints" \
        "${CHECKPOINT_MODELS[@]}"
    provisioning_get_files \
        "${COMFYUI_DIR}/models/unet" \
        "${UNET_MODELS[@]}"
    provisioning_get_files \
        "${COMFYUI_DIR}/models/diffusion_models" \
        "${DIFFUSION_MODELS[@]}"
    provisioning_get_files \
        "${COMFYUI_DIR}/models/lora" \
        "${LORA_MODELS[@]}"
    provisioning_get_files \
        "${COMFYUI_DIR}/models/controlnet" \
        "${CONTROLNET_MODELS[@]}"
    provisioning_get_files \
        "${COMFYUI_DIR}/models/vae" \
        "${VAE_MODELS[@]}"
    provisioning_get_files \
        "${COMFYUI_DIR}/models/esrgan" \
        "${ESRGAN_MODELS[@]}"
    provisioning_get_files \
        "${COMFYUI_DIR}/models/upscale_models" \
        "${UPSCALE_MODELS[@]}"
    provisioning_get_files \
        "${COMFYUI_DIR}/models/text_encoders" \
        "${TEXT_ENCODER_MODELS[@]}"
    provisioning_get_files \
        "${COMFYUI_DIR}/models/clip" \
        "${CLIP_MODELS[@]}"

    provisioning_print_end
}

function provisioning_get_apt_packages() {
    if [[ -n "${APT_PACKAGES[*]}" ]]; then
        printf "Installing APT packages...\n"
        sudo ${APT_INSTALL:-apt-get install -y} ${APT_PACKAGES[@]}
    fi
}

function provisioning_get_pip_packages() {
    if [[ -n "${PIP_PACKAGES[*]}" ]]; then
        printf "Installing PIP packages...\n"
        pip install --no-cache-dir ${PIP_PACKAGES[@]}
    fi
}

function provisioning_get_nodes() {
    if [[ ${#NODES[@]} -eq 0 ]]; then
        return 0
    fi

    printf "\nProcessing custom nodes...\n"
    for repo in "${NODES[@]}"; do
        dir="${repo##*/}"
        path="${COMFYUI_DIR}/custom_nodes/${dir}"
        requirements="${path}/requirements.txt"

        if [[ -d $path ]]; then
            if [[ ${AUTO_UPDATE,,} != "false" ]]; then
                printf "Updating node: %s...\n" "${repo}"
                ( cd "$path" && git pull )
                if [[ -e $requirements ]]; then
                   pip install --no-cache-dir -r "$requirements"
                fi
            fi
        else
            printf "Downloading node: %s...\n" "${repo}"
            git clone "${repo}" "${path}" --recursive
            if [[ -e $requirements ]]; then
                pip install --no-cache-dir -r "${requirements}"
            fi
        fi
    done
}

function provisioning_get_files() {
    if [[ -z $2 ]]; then return 0; fi

    dir="$1"
    mkdir -p "$dir"
    shift
    arr=("$@")

    if [[ ${#arr[@]} -eq 0 ]]; then
        return 0
    fi

    printf "\nDownloading %s file(s) to %s...\n" "${#arr[@]}" "$dir"
    for url in "${arr[@]}"; do
        printf "  -> %s\n" "${url}"
        provisioning_download "${url}" "${dir}"
    done
}

function provisioning_print_header() {
    printf "\n##############################################\n"
    printf "#                                            #\n"
    printf "#          Provisioning ComfyUI              #\n"
    printf "#                                            #\n"
    printf "#         This will take some time           #\n"
    printf "#                                            #\n"
    printf "##############################################\n\n"
}

function provisioning_print_end() {
    printf "\n##############################################\n"
    printf "#                                            #\n"
    printf "#      Provisioning complete!                #\n"
    printf "#                                            #\n"
    printf "##############################################\n\n"
}

function provisioning_has_valid_hf_token() {
    [[ -n "$HF_TOKEN" ]] || return 1
    url="https://huggingface.co/api/whoami-v2"

    response=$(curl -o /dev/null -s -w "%{http_code}" -X GET "$url" \
        -H "Authorization: Bearer $HF_TOKEN" \
        -H "Content-Type: application/json")

    if [ "$response" -eq 200 ]; then
        return 0
    else
        return 1
    fi
}

function provisioning_has_valid_civitai_token() {
    [[ -n "$CIVITAI_TOKEN" ]] || return 1
    url="https://civitai.com/api/v1/models?hidden=1&limit=1"

    response=$(curl -o /dev/null -s -w "%{http_code}" -X GET "$url" \
        -H "Authorization: Bearer $CIVITAI_TOKEN" \
        -H "Content-Type: application/json")

    if [ "$response" -eq 200 ]; then
        return 0
    else
        return 1
    fi
}

# Download from $1 URL to $2 directory path
function provisioning_download() {
    local url="$1"
    local dest_dir="$2"
    local auth_token=""

    # Check if we need authentication
    if [[ -n $HF_TOKEN && $url =~ ^https://([a-zA-Z0-9_-]+\.)?huggingface\.co(/|$|\?) ]]; then
        auth_token="$HF_TOKEN"
    elif [[ -n $CIVITAI_TOKEN && $url =~ ^https://([a-zA-Z0-9_-]+\.)?civitai\.com(/|$|\?) ]]; then
        auth_token="$CIVITAI_TOKEN"
    fi

    # Download with or without authentication
    if [[ -n $auth_token ]]; then
        wget --header="Authorization: Bearer $auth_token" \
             -qnc --content-disposition --show-progress \
             -e dotbytes="${3:-4M}" -P "$dest_dir" "$url"
    else
        wget -qnc --content-disposition --show-progress \
             -e dotbytes="${3:-4M}" -P "$dest_dir" "$url" || \
        wget -q --show-progress -N -P "$dest_dir" "$url"
    fi
}

### MAIN EXECUTION ###

# Check if a config file was provided
if [[ -n "$1" && -f "$1" ]]; then
    printf "Loading configuration from: %s\n" "$1"
    source "$1"
fi

# Allow user to disable provisioning
if [[ -f /.noprovisioning ]]; then
    printf "Provisioning disabled by /.noprovisioning file\n"
    exit 0
fi

# Only run provisioning if called directly (not sourced)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    provisioning_start
fi
