#!/bin/sh

if command -v darwin-rebuild >/dev/null; then
	echo "Nix-Darwin already installed"
	exit 0
fi

nix run nix-darwin -- switch --flake $(pwd)
