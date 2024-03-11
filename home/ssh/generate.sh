#!/usr/bin/env -S nix shell nixpkgs#openssh nixpkgs#bash --command bash

keys="github gitlab codeberg"

for key in $keys; do
	if [ -f ~/.ssh/$key.ssh ]; then
		echo "SSH key pair for $key already exists"
		continue
	fi

	echo "Generating SSH key pair for $key"
	ssh-keygen -t rsa -b 4096 -C $key -f ~/.ssh/$key.ssh
done
