#!/bin/sh

./setup/install-nix.sh

. ./setup/vars.sh

if [ -n "$IS_MAC" ]; then
  echo "Installing nix-darwin"
  ./setup/install-nix-darwin.sh
elif [ -n "$IS_WSL" ]; then
  echo "Installing home-manager in WSL"
  ./setup/install-home-manager.sh
else
  echo "Installing home-manager"
  ./setup/install-home-manager.sh
fi
