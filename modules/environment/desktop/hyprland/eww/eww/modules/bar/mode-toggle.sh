#!/usr/bin/env bash

set -euo pipefail

script_dir="$(dirname -- "${BASH_SOURCE[0]}")"
source "$script_dir/mode-config.sh"

write="$script_dir/mode-write.sh"

if test -f "$mode_file"; then
  if test "$(cat "$mode_file")" = "dark"; then
    "$write" "light"
  else
    "$write" "dark"
  fi
else
  "$write" "dark"
fi
