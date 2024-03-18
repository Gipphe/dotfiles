#!/usr/bin/env -S nix shell nixpkgs#openssh nixpkgs#bash --command bash

services="github gitlab codeberg"
keys="github gitlab codeberg"

for key in $keys; do
	if [ -f ~/.ssh/$key.ssh ]; then
		echo "SSH key pair for $key already exists"
		continue
	fi

	echo "Generating SSH key pair for $key"
	ssh-keygen -t rsa -b 4096 -C $key -f ~/.ssh/$key.ssh
done
for f in github.ssh gitlab.ssh codeberg.ssh github.ssh.pub gitlab.ssh.pub codeberg.ssh.pub
	set -lx EDITOR "cp /dev/stdin"
	cat ~/.ssh/$f |  agenix -e VNB-MB-Pro-$f.age
end


