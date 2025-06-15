#!/usr/bin/env nix
#! nix --extra-experimental-features 'flakes nix-command' shell nixpkgs#openssh nixpkgs#sops nixpkgs#coreutils --command bash

log() {
    echo "$@" >&2
}

help() {
    log "Usage: generate-ssh-key.sh <key_name>"
    log ""
    log "Arguments:"
    log "  key_name: string, required"
}

key_name="$1"
if test -z "$key_name"; then
    echo "Missing key_name arg".
    help
    exit 1
fi

temp_key=$(mktemp)
echo "y" | ssh-keygen -t ed25519 -f "$temp_key" -N ''

dir="$(dirname -- "${BASH_SOURCE[0]}")"

dest="$dir/$key_name"
sops "--filename-override=secrets/$key_name" -e /dev/stdin <"$temp_key" >"$dest"
sops "--filename-override=secrets/$key_name.pub" -e /dev/stdin <"$temp_key.pub" >"$dest.pub"
rm "$temp_key" "$temp_key.pub"
log "Generated and encrypted key in $dest"
