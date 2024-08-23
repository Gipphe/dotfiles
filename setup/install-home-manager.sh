#!/bin/sh

if command -v home-manager >/dev/null; then
  echo "Home-Manager already installed"
  exit 0
fi

nix --extra-experimental-features nix-command --extra-experimental-features flakes run github:nix-community/home-manager/master -- init --switch "$(pwd)"
