#!/bin/bash
# Character Master Standalone Provisioning Script for Vast.ai
# This script downloads the modular provisioning system and runs it
#
# Usage in Vast.ai template:
# PROVISIONING_SCRIPT=https://raw.githubusercontent.com/BiloxiStudios/ComfyConfigs/main/deployment/CharacterMasterProvisioning.sh

set -e

# Activate venv if it exists (Vast.ai environment)
if [[ -f /venv/main/bin/activate ]]; then
    source /venv/main/bin/activate
fi

# Configuration
REPO_OWNER="BiloxiStudios"
REPO_NAME="ComfyConfigs"
BRANCH="${PROVISIONING_BRANCH:-main}"  # Allow override via env var
REPO_URL="https://raw.githubusercontent.com/${REPO_OWNER}/${REPO_NAME}/${BRANCH}/deployment"
TEMP_DIR="/tmp/comfyui-provisioning"

echo "=========================================="
echo "Character Master Provisioning"
echo "Branch: ${BRANCH}"
echo "=========================================="

# Create temp directory
mkdir -p "$TEMP_DIR"
cd "$TEMP_DIR"

# Download the modular provisioning files
echo "Downloading provisioning scripts..."
wget -q "$REPO_URL/base-provisioning.sh" -O base-provisioning.sh
wget -q "$REPO_URL/configs/character-master-config.sh" -O character-master-config.sh

# Make executable
chmod +x base-provisioning.sh

# Source the config and run the base provisioning
echo "Starting provisioning..."
source character-master-config.sh
bash base-provisioning.sh

# Cleanup
cd /
rm -rf "$TEMP_DIR"

echo ""
echo "=========================================="
echo "Character Master provisioning complete!"
echo "=========================================="
