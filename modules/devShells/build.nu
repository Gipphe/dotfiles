#!/usr/bin/env nu

use ./build-nix-on-droid.nu
use ./build-nixos.nu

export def main [...rest]: nothing -> nothing {
    if (which nixos-rebuild | length | $in > 0) {
        build-nixos ...($rest)
    } else if (which nix-on-droid | length | $in > 0) {
        build-nix-on-droid ...($rest)
    } else {
        error make "This is not a NixOS or nix-on-droid system"
    }
}
