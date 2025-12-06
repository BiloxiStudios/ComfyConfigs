#!/bin/bash
# Character Master Serverless Provisioning Script for Vast.ai
# Based on Vast.ai serverless template with Character Master workflow
#
# Usage in Vast.ai serverless template:
# PROVISIONING_SCRIPT=https://raw.githubusercontent.com/BiloxiStudios/ComfyConfigs/main/deployment/serverless/CharacterMasterServerless.sh

set -euo pipefail

# Configuration
REPO_OWNER="BiloxiStudios"
REPO_NAME="ComfyConfigs"
BRANCH="${PROVISIONING_BRANCH:-main}"
REPO_URL="https://raw.githubusercontent.com/${REPO_OWNER}/${REPO_NAME}/${BRANCH}/deployment"

main() {
    echo "=========================================="
    echo "Character Master Serverless Provisioning"
    echo "Branch: ${BRANCH}"
    echo "=========================================="

    # Run standard Character Master provisioning
    provision_character_master

    # Set up serverless-specific features
    set_cleanup_job

    echo ""
    echo "=========================================="
    echo "Serverless provisioning complete!"
    echo "=========================================="
}

# Provision Character Master models and nodes
provision_character_master() {
    echo "Running Character Master provisioning..."

    # Download and run the standard provisioning script
    TEMP_DIR="/tmp/comfyui-provisioning"
    mkdir -p "$TEMP_DIR"
    cd "$TEMP_DIR"

    # Download the modular provisioning files
    wget -q "$REPO_URL/base-provisioning.sh" -O base-provisioning.sh
    wget -q "$REPO_URL/configs/character-master-config.sh" -O character-master-config.sh

    # Make executable
    chmod +x base-provisioning.sh

    # Source the config and run the base provisioning
    source character-master-config.sh
    bash base-provisioning.sh

    # Cleanup
    cd /
    rm -rf "$TEMP_DIR"
}

# Add a cron job to remove older (oldest +24 hours) output files if disk space is low
set_cleanup_job() {
    echo "Setting up disk space cleanup job..."

    if [[ ! -f /opt/instance-tools/bin/clean-output.sh ]]; then
        mkdir -p /opt/instance-tools/bin
        cat > /opt/instance-tools/bin/clean-output.sh << 'CLEAN_OUTPUT'
#!/bin/bash
output_dir="${WORKSPACE:-/workspace}/ComfyUI/output/"
min_free_mb=512
available_space=$(df -m "${output_dir}" | awk 'NR==2 {print $4}')
if [[ "$available_space" -lt "$min_free_mb" ]]; then
    oldest=$(find "${output_dir}" -mindepth 1 -type f -printf "%T@\n" 2>/dev/null | sort -n | head -1 | awk '{printf "%.0f", $1}')
    if [[ -n "$oldest" ]]; then
        cutoff=$(awk "BEGIN {printf \"%.0f\", ${oldest}+86400}")
        # Only delete files
        find "${output_dir}" -mindepth 1 -type f ! -newermt "@${cutoff}" -delete
        # Delete broken symlinks
        find "${output_dir}" -mindepth 1 -xtype l -delete
        # Now delete *empty* directories separately
        find "${output_dir}" -mindepth 1 -type d -empty -delete
    fi
fi
CLEAN_OUTPUT
        chmod +x /opt/instance-tools/bin/clean-output.sh
    fi

    if ! crontab -l 2>/dev/null | grep -qF 'clean-output.sh'; then
        (crontab -l 2>/dev/null; echo '*/10 * * * * /opt/instance-tools/bin/clean-output.sh') | crontab -
    fi

    echo "Cleanup job configured (runs every 10 minutes)"
}

main
