#!/bin/sh

./setup/install-nix.sh

IS_NIXOS="$(if test -d "/etc/nixos"; then echo "yes"; else echo ""; fi)"
IS_MAC="$(if test "$(uname)" = 'Darwin'; then echo "yes"; else echo ""; fi)"

if test -n "$IS_NIXOS"; then
  echo "This machine is a NixOS machine. Running nixos-rebuild."
  nixos-rebuild switch --flake "$(pwd)"
elif test -n "$IS_MAC"; then
  echo "Installing nix-darwin"
  ./setup/install-nix-darwin.sh
elif test "$(uname)" = "Linux"; then
  echo "Installing home-manager"
  ./setup/install-home-manager.sh
else
  echo "Unrecognized machine type. Unsure what to install next."
  exit 1
fi
