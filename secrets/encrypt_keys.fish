#!/usr/bin/env -S nix shell nixpkgs#openssh nixpkgs#fish nixpkgs#sops --command fish

set -l host_public_key /etc/ssh/ssh_host_ed25519_key.pub
set -l user_public_key $HOME/.ssh/id_ed25519.pub
set -l dir (dirname -- (status --current-filename))

if ! grep -q "$(hostname)" $dir/secrets.nix
    if ! test -e $host_public_key
        echo "Missing host public key at $host_public_key"
        echo "You have to set services.ssh-agent.enable to true, enabling the"
        echo "ssh-agent and creating a host key."
        exit 1
    end

    if ! test -e $user_public_key
        echo "No user key found at $user_public_key"
        echo "Generating new user key"
        ssh-keygen -f ~/.ssh/id_ed25519
    end

    echo "Add the following public keys to $dir/secrets.nix for host $(hostname)"
    echo ""
    echo "Host public key:"
    echo ""
    cat $host_public_key
    echo ""
    echo "User public key:"
    echo ""
    cat $user_public_key
    exit 0
end

set -l services github gitlab codeberg
set -l extensions .ssh

set -l keys
for s in $services
    for e in $extensions
        set -a keys "$s$e"
    end
end

# Generate SSH keys
for service in $services
    set -l key_path "$HOME/.ssh/$service.ssh"
    echo "Checking for $service's key at $key_path"
    if test -e $key_path
        echo "SSH key pair for $service already exists"
        continue
    end

    echo "Generating SSH key pair for $service"
    ssh-keygen -t rsa -b 4096 -C $service -f ~/.ssh/$service.ssh
end


# Encrypt keys with sops
pushd $dir
for k in $keys
    set -l secret_name "$(hostname)-$k"
    set -l encrypted_dest "$dir/$secret_name"
    echo "Encrypting $k to $encrypted_dest"
    if test -f $encrypted_dest
        echo "Encrypted file already exists" >&2
        continue
    end
    set -lx EDITOR "cp /dev/stdin"
    sops $secret_name <$HOME/.ssh/$k
    or begin
        echo "Failed to encrypt secret"
        exit 1
    end
end
popd
