# ComfyUI Deployment Scripts

This directory contains modular provisioning scripts for setting up ComfyUI environments with different workflow configurations.

## Structure

```
deployment/
├── base-provisioning.sh              # Core provisioning engine (based on Vast.ai)
├── configs/                          # Workflow-specific configurations
│   ├── character-master-config.sh
│   └── template-config.sh
├── serverless/                       # Serverless-specific scripts
│   ├── CharacterMasterServerless.sh
│   └── reference/
│       └── vast-ai-serverless-template.sh
├── reference/                        # Reference scripts
│   └── vast-ai-default.sh
├── CharacterMasterSetup.sh           # Character Master workflow setup
├── CharacterMasterProvisioning.sh    # Standalone provisioning for Vast.ai
└── README.md                         # This file
```

## Quick Start

### Character Master Workflow

```bash
bash deployment/CharacterMasterSetup.sh
```

This will:
- Install all required custom nodes
- Download all necessary models (Qwen, Flux, ControlNet, etc.)
- Set up the complete Character Master workflow environment

### Vast.ai On-Demand Instances

Set this environment variable in your Vast.ai template:

```bash
PROVISIONING_SCRIPT=https://raw.githubusercontent.com/BiloxiStudios/ComfyConfigs/main/deployment/CharacterMasterProvisioning.sh
```

Optional environment variables:
```bash
COMFYUI_API_KEY=your_comfy_org_api_key  # Auto-configure ComfyUI API key
HF_TOKEN=your_huggingface_token         # For gated models
CIVITAI_TOKEN=your_civitai_token        # For CivitAI models
```

### Vast.ai Serverless Instances

For serverless deployments, use the serverless-specific script:

```bash
PROVISIONING_SCRIPT=https://raw.githubusercontent.com/BiloxiStudios/ComfyConfigs/main/deployment/serverless/CharacterMasterServerless.sh
```

The serverless script includes:
- All Character Master models and custom nodes
- Automatic disk space cleanup (runs every 10 minutes)
- Removes output files older than 24 hours when disk space < 512MB
- Same environment variable support (COMFYUI_API_KEY, HF_TOKEN, etc.)

## How It Works

### Base Provisioning Script

`base-provisioning.sh` provides the core functionality:
- **Package Management**: Install APT and PIP packages
- **Custom Nodes**: Clone and update ComfyUI custom nodes from GitHub
- **Model Downloads**: Download models with support for HuggingFace and CivitAI authentication
- **Auto-Updates**: Optionally update existing nodes (controlled by `AUTO_UPDATE` variable)
- **Modular Design**: Can be used with different configuration files

### Configuration Files

Each workflow has its own configuration file in `configs/` that defines:
- `APT_PACKAGES`: System packages to install
- `PIP_PACKAGES`: Python packages to install
- `NODES`: GitHub repositories for custom nodes
- `DIFFUSION_MODELS`: Diffusion/UNet models
- `TEXT_ENCODER_MODELS`: Text encoder models
- `VAE_MODELS`: VAE models
- `CONTROLNET_MODELS`: ControlNet models
- `UPSCALE_MODELS`: Upscaler models
- `CHECKPOINT_MODELS`: Checkpoint models
- `CLIP_MODELS`: CLIP models
- `LORA_MODELS`: LoRA models

### Workflow-Specific Scripts

Scripts like `CharacterMasterSetup.sh` are simple wrappers that:
1. Source the workflow configuration
2. Call the base provisioning script
3. Provide a clean entry point for each workflow

## Creating a New Workflow

1. **Create a configuration file** in `configs/`:
   ```bash
   cp configs/character-master-config.sh configs/my-workflow-config.sh
   ```

2. **Edit the configuration** to define your models and nodes:
   ```bash
   vim configs/my-workflow-config.sh
   ```

3. **Create a setup script**:
   ```bash
   cat > MyWorkflowSetup.sh << 'EOF'
   #!/bin/bash
   set -e
   SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
   source "${SCRIPT_DIR}/configs/my-workflow-config.sh"
   bash "${SCRIPT_DIR}/base-provisioning.sh" "${SCRIPT_DIR}/configs/my-workflow-config.sh"
   echo "My Workflow setup complete!"
   EOF
   chmod +x MyWorkflowSetup.sh
   ```

4. **Run your setup**:
   ```bash
   bash MyWorkflowSetup.sh
   ```

## Environment Variables

### Authentication

- `HF_TOKEN`: HuggingFace API token for downloading gated models
- `CIVITAI_TOKEN`: CivitAI API token for downloading models
- `COMFYUI_API_KEY`: ComfyUI API key (from comfy.org) - automatically configured in ComfyUI settings

Set these before running the provisioning script:
```bash
export HF_TOKEN="your_token_here"
export CIVITAI_TOKEN="your_token_here"
export COMFYUI_API_KEY="your_comfyui_api_key"
bash CharacterMasterSetup.sh
```

**For Vast.ai**: Set these as environment variables in your instance template, and the provisioning script will automatically configure them.

### Configuration

- `WORKSPACE`: Base workspace directory (default: `/workspace`)
- `AUTO_UPDATE`: Enable automatic updates for existing nodes (default: `true`)

### Disabling Provisioning

Create a `/.noprovisioning` file to skip all provisioning:
```bash
touch /.noprovisioning
```

## Features

### Smart Downloads
- Automatically handles authentication for HuggingFace and CivitAI
- Resumes interrupted downloads (`-N` flag)
- Shows progress during downloads
- Uses content-disposition to preserve filenames

### Custom Node Management
- Clones nodes if they don't exist
- Updates existing nodes (if `AUTO_UPDATE` is enabled)
- Automatically installs requirements from `requirements.txt`
- Supports recursive cloning for nodes with submodules

### Model Organization
Models are automatically organized into the correct ComfyUI directories:
- `models/checkpoints/` - Checkpoint models
- `models/unet/` - UNet models
- `models/diffusion_models/` - Diffusion models
- `models/lora/` - LoRA models
- `models/vae/` - VAE models
- `models/controlnet/` - ControlNet models
- `models/upscale_models/` - Upscaler models
- `models/text_encoders/` - Text encoder models
- `models/clip/` - CLIP models

## Character Master Workflow

The Character Master workflow includes:

### Models
- **Qwen Image Models**: Advanced image generation and editing
  - Lightning models for fast generation
  - FP8 quantized models for efficiency
  - Text encoders for prompt understanding

- **Flux Models**: Additional generation capabilities
  - Flux Dev checkpoint
  - CLIP and T5XXL text encoders
  - Flux VAE

- **ControlNet**: Qwen ControlNet Union for guided generation

- **Upscaling**: Real-ESRGAN 4x for image enhancement

### Custom Nodes
- **ComfyUI-KJNodes**: Kijai's essential nodes
- **ComfyUI-Florence2**: Florence2 integration
- **ComfyUI_UltimateSDUpscale**: Ultimate SD upscaling
- **ComfyUI_essentials**: Essential utility nodes

## Troubleshooting

### Downloads Fail
- Check your internet connection
- Verify authentication tokens if downloading gated models
- Ensure sufficient disk space

### Nodes Don't Install
- Check that git is installed and accessible
- Verify the repository URLs are correct
- Look for errors in requirements.txt installation

### Updates Not Working
- Set `AUTO_UPDATE=false` to disable automatic updates
- Manually update nodes by running `git pull` in their directories

## Credits

- Based on the [Vast.ai default provisioning script](https://github.com/vast-ai/base-image)
- Enhanced for multi-workflow support and better organization
