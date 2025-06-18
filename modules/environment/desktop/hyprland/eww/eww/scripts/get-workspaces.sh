#!/usr/bin/env bash

spaces() {
  hyprctl workspaces -j | jq -c 'map(.id)'
}

spaces
socat -u "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" - | while read -r line; do
  spaces
done
