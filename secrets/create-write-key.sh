#!/usr/bin/env nix
#! nix --extra-experimental-features ``flakes nix-command`` shell nixpkgs#age --command bash

mkdir -p ~/.config/sops/age

key_dest="$HOME/.config/sops/age/keys.txt"

if test -e "$key_dest"; then
    echo "Key already exists" >&2
    exit 1
fi

age-keygen -o "$key_dest"
