# Biloxi Studios Comfy Provisioning
Internal and Shared Workflows and auto configs


How to use - run from instance

'''
cd /workspace
wget -O setup_my_comfy.sh https://raw.githubusercontent.com/BiloxiStudios/ComfyConfigs/refs/heads/main/deployment/CharacterMasterSetup.sh
chmod +x setup_my_comfy.sh
./setup_my_comfy.sh

supervisorctl restart comfyui
'''
