#!/usr/bin/env bash

set -euo pipefail

script_dir="$(dirname -- "${BASH_SOURCE[0]}")"
source "$script_dir/mode-config.sh"

if test "$#" -lt 1; then
  echo "Usage: $0 <message>" >&2
  exit 1
fi

if ! test -p "$pipe_path"; then
  echo "Pipe does not exist: $pipe_path"
  exit 2
fi

echo "$1" >"$mode_file"
echo "$1" >"$pipe_path"
