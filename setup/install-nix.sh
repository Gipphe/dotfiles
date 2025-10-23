#!/bin/sh

if command -v nix >/dev/null; then
  echo "Nix already installed"
  exit 0
fi

if ! command -v curl >/dev/null; then
  sudo apt update
  sudo apt-get install -y curl
fi

curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
