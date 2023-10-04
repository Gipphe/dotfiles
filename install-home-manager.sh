#!/bin/bash

if ! which nix 1>/dev/null; then
	if ! which curl 1>/dev/null; then
		sudo apt install -y curl
	fi

	IS_WSL=$(if [ ! -z $(grep -E 'microsoft|WSL' /proc/sys/kernel/osrelease) ]; then echo true; else echo false; fi)

	if [ "$IS_WSL" = true ]; then
		echo "Installing single-user version of Nix since we're in WSL"
		sh <(curl -L https://nixos.org/nix/install) --no-daemon
	else
		echo "Installing multi-user version of Nix"
		sh <(curl -L https://nixos.org/nix/install) --daemon
	fi
else
	echo "Nix is already installed"
fi

if ! $(nix-channel --list | grep -q home-manager); then
	# Add home-manager channel
	nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
	nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs
	nix-channel --update
else
	echo "home-manager channel already added"
fi

if ! which home-manager 1>/dev/null; then
	# Install home-manager
	nix-shell '<home-manager>' -A install
else
	echo "home-manager already installed"
fi

# See man home-configuration.nix for info on configuring home-manager

if [ "$1" = "nix" ]; then
	cfg=~/.config/nix/nix.conf
	if ! $(grep -q 'nix-command flakes' $cfg 2>/dev/null); then
		echo "Adding experimental features to nix.conf"
		mkdir -p $(dirname $cfg)
		echo "experimental-features = nix-command flakes" >> $cfg
	else
		echo "Experimental features already enabled"
	fi
else
	echo "Experimental features need to be enabled somewhere, but you didn't specify where."
fi
