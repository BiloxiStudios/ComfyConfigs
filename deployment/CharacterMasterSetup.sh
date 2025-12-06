#!/bin/bash
# Character Master Setup Script
# This script provisions a ComfyUI environment for the Character Master workflow
# It uses the modular provisioning system with workflow-specific configurations

set -e

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Source the character master configuration
source "${SCRIPT_DIR}/configs/character-master-config.sh"

# Run the base provisioning script
bash "${SCRIPT_DIR}/base-provisioning.sh" "${SCRIPT_DIR}/configs/character-master-config.sh"

echo "Character Master setup complete!"
