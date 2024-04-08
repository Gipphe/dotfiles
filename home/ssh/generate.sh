#!/usr/bin/env bash

keys="github gitlab codeberg"

for key in $keys; do
  if [ -f "$HOME/.ssh/$key.ssh" ]; then
    echo "SSH key pair for $key already exists"
    continue
  fi

  echo "Generating SSH key pair for $key"
  ssh-keygen -t rsa -b 4096 -C "$key" -f "$HOME/.ssh/$key.ssh"
done
