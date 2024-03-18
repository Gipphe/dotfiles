#!/usr/bin/env -S nix shell nixpkgs#openssh nixpkgs#fish --command fish

argparse --name=setup_keys n/hostname= -- $argv
or return

set -l services github gitlab codeberg
set -l extensions .ssh .ssh.pub

set -l keys
for s in $services
    for e in $extensions
        set -a keys $s$e
    end
end

# Generate SSH keys
for key in $keys
    if test -f ~/.ssh/$key.ssh
        echo "SSH key pair for $key already exists"
        continue
    end

    echo "Generating SSH key pair for $key"
    ssh-keygen -t rsa -b 4096 -C $key -f ~/.ssh/$key.ssh
    done
end

set -l dir (dirname -- (status --current-filename))

# Encrypt keys with agenix
for k in $keys
    set -l f VNB-MB-Pro-$k.age
    if test -f $f
        continue
    end
    set -lx EDITOR "cp /dev/stdin"
    agenix -e $dir/$f <~/.ssh/$k
end
