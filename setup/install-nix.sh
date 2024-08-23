#!/bin/sh

if command -v nix >/dev/null; then
  echo "Nix already installed"
  exit 0
fi

if ! command -v curl >/dev/null; then
  if test "$(uname)" = "Darwin"; then
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

curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
