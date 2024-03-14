#!/bin/sh

if command -v nix >/dev/null; then
	echo "Nix already installed"
	exit 0
fi

source ./setup/vars.sh

if ! command -v curl >/dev/null; then
	if [ -f "$IS_MAC" ]; then
		if command -v brew >/dev/null; then
			brew install curl
		else
			echo "Homebrew not installed. Unable to install curl."
			exit 1
		fi
	else
		sudo apt update
		sudo apt-get install -y curl
	fi
fi

if [ -f "$IS_MAC" ]; then
	curl -L https://nixos.org/nix/install | sh -i
elif [ -f "$IS_WSL" ]; then
	curl -L https://nixos.org/nix/install | sh -i -- --daemon
else
	curl -L https://nixos.org/nix/install | sh -i -- --daemon
fi
