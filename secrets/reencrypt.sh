#!/usr/bin/env nix
#! nix --extra-experimental-features ``flakes nix-command`` shell nixpkgs#sops nixpkgs#coreutils --command bash

process_file() {
    echo "Processing $1"
    backup=$(mktemp)
    cp "$1" "$backup"

    if sops decrypt --in-place "$1" 2>/dev/null && sops encrypt --in-place "$1" 2>/dev/null; then
        echo "Re-encrypted $1"
        rm -f "$backup"
    else
        echo "Unable to re-encrypt $1, skipping" >&2
        mv "$backup" "$1"
    fi
}
export -f process_file

find . -type f ! \( -iname '*.nix' -o -iname '*.sh' \) -print0 |
    while IFS= read -r -d '' file; do
        process_file "$file"
    done
