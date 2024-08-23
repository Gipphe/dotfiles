#!/bin/sh

if command -v darwin-rebuild >/dev/null; then
  echo "Nix-Darwin already installed"
  exit 0
fi

nix --extra-experimental-features nix-command --extra-experimental-features flakes run github:LnL7/nix-darwin -- switch --flake "$(pwd)"
