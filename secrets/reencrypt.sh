#!/usr/bin/env nix
#! nix --extra-experimental-features ``flakes nix-command`` shell nixpkgs#parallel nixpkgs#sops nixpkgs#coreutils --command bash

process_file() {
    tmp=$(mktemp)
    sops decrypt "$1" | sops encryupt --filename-override "$1" >"$tmp"
    mv "$tmp" "$1"
}
export -f process_file

find . -type f ! \( -iname '*.nix' -o -iname '*.sh' \) -print0 |
    parallel -0 process_file
