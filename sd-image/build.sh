#!/usr/bin/env bash

d="$(dirname -- "${BASH_SOURCE[0]}")"
nix-build '<nixpkgs/nixos>' -A config.system.build.sdImage -I "nixos-config=$d/sd-image.nix" --argstr system aarch64-linux
