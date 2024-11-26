#!/bin/bash
# deploy-nix.sh

set -e # Exit on error

# Replace these with your actual paths and credentials
NIXOS_HOST="nix"
LOCAL_PATH="/home/aaronk/repo/nixdots" # Your actual WSL path
REMOTE_PATH="/home/anarcho/nixcfg"     # Path on NixOS VM

# Check if local directory exists
if [ ! -d "$LOCAL_PATH" ]; then
  echo "Error: Local directory $LOCAL_PATH does not exist"
  exit 1
fi

echo "Syncing files to NixOS VM..."
rsync -avz --delete \
  --exclude '.git' \
  --exclude 'result' \
  "$LOCAL_PATH/" \
  "$NIXOS_HOST:$REMOTE_PATH/"

echo "Running nixos-rebuild..."
# Use SUDO_ASKPASS for password prompt or setup passwordless sudo for nixos-rebuild
ssh -t "$NIXOS_HOST" "cp -r /etc/nixos/hardware-configuration.nix ~/nixcfg/hosts/vm && sudo nixos-rebuild switch --flake $REMOTE_PATH#vm"
#ssh -t "$NIXOS_HOST" "sudo nixos-rebuild switch --flake $REMOTE_PATH#vm-anarcho"
