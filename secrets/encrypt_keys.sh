#!/usr/bin/env bash

n() {
    nix --extra-experimental-features 'flakes nix-command' "$@"
}

dir="$(dirname -- "${BASH_SOURCE[0]}")"
ssh_keygen="n shell nixpkgs#openssh --command ssh-keygen --"
sops="n shell nixpkgs#sops --"

services=(github gitlab codeberg)
ext=.ssh

keys=()
for s in "${services[@]}"; do
    keys+=("$s$ext")
done

# Generate SSH keys
for service in "${services[@]}"; do
    key_path="$HOME/.ssh/$service.ssh"
    echo "Checking for $service's key at $key_path"
    if test -e "$key_path"; then
        echo "SSH key pair for $service already exists"
        continue
    fi

    echo "Generating SSH key pair for $service"
    $ssh_keygen -t rsa -b 4096 -C "$service" -f "$HOME/.ssh/$service.ssh"
done

# Encrypt keys with sops
pushd "$dir" || exit
for k in "${keys[@]}"; do
    secret_name="$(hostname)-$k"
    encrypted_dest="$dir/$secret_name"
    echo "Encrypting $k to $encrypted_dest"
    if test -f "$encrypted_dest"; then
        echo "Encrypted file already exists" >&2
        continue
    fi
    EDITOR="cp /dev/stdin" $sops "$secret_name" <"$HOME/.ssh/$k"
    if test "$?" != "0"; then
        echo "Failed to encrypt secret"
        exit 1
    fi
done
popd || exit
