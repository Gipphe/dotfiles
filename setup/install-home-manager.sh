#!/bin/sh

if command -v home-manager >/dev/null; then
	echo "Home-Manager already installed"
	exit 0
fi

nix run home-manager/master -- init --switch $(pwd)
