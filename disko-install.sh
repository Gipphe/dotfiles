#!/usr/bin/env bash

set -euo pipefail

host="$1"
disk_device="$2"

info() {
  echo "$@" >&2
}
print_help() {
  info "Usage: ./disko-install.sh <hostname> <disk_device_path>"
  info "  hostname:"
  info "    hostname of the machine to install"
  info "  disk_device_path:"
  info "    Device path to disk to install on."
  info "    Example: /dev/sda"
}

if test -z "$host"; then
  info "Missing host argument"
  print_help
  exit 1
fi

if test -z "$disk_device"; then
  info "Missing disk_device_path argument"
  print_help
  exit 1
fi

key="/tmp/keys.txt"
mkdir -p "$(dirname -- "$key")"
if test ! -f "$key"; then
  nix --extra-experimental-features 'flakes nix-command' shell "nixpkgs#age" -c age-keygen -o "$key"
fi

export SOPS_AGE_KEY_FILE="$key"
sudo chown root:root "$key"
sudo --preserve-env=SOPS_AGE_KEY_FILE nix \
  --extra-experimental-features 'flakes nix-command' \
  run 'github:nix-community/disko/latest#disko-install' \
  -- \
  --write-efi-boot-entries \
  --flake ".#$host" \
  --disk "main" \
  "$disk_device"

mkdir -p /tmp/built-system
sudo mount "$disk_device" /tmp/built-system
dest_key="/tmp/built-system/home/gipphe/.config/sops/age/keys.txt"
mkdir -p "$(dirname -- "$dest_key")"
sudo cp "$key" "$dest_key"
sudo chown 1000:1000 "$dest_key"
