#!/usr/bin/env bash

host_public_key="/etc/ssh/ssh_host_ed25519_key.pub"
user_public_key="$HOME/.ssh/id_ed25519.pub"
dir="$(dirname -- "${BASH_SOURCE[0]}")"

grep="nix run nixpkgs#gnugrep --"
ssh_keygen="nix shell nixpkgs#openssh --command ssh-keygen --"
sops="nix shell nixpkgs#sops --"

if ! $grep -q "$(hostname)" "$dir/secrets.nix"; then
    if ! test -e "$host_public_key"; then
        echo "Missing host public key at $host_public_key"
        echo "You have to set services.ssh-agent.enable to true, enabling the"
        echo "ssh-agent and creating a host key."
        exit 1
    fi

    if ! test -e "$user_public_key"; then
        echo "No user key found at $user_public_key"
        echo "Generating new user key"
        $ssh_keygen -f ~/.ssh/id_ed25519
    fi

    echo "Add the following public keys to $dir/secrets.nix for host $(hostname)"
    echo ""
    echo "Host public key:"
    echo ""
    cat "$host_public_key"
    echo ""
    echo "User public key:"
    echo ""
    cat "$user_public_key"
    exit 0
fi

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
