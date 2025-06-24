#!/usr/bin/env bash

set -euo pipefail

script_dir="$(dirname -- "${BASH_SOURCE[0]}")"
source "$script_dir/mode-config.sh"

trap 'rm -f "$pipe_path"' EXIT

if ! test -f "$mode_file"; then
  mkdir -p "$(dirname -- "$mode_file")"
  echo "dark" >"$mode_file"
fi

test -p "$pipe_path" && rm -f "$pipe_path"
mkfifo "$pipe_path"

cat "$mode_file"

echo "Listening on $pipe_path" >&2

while read -r line <"$pipe_path"; do
  echo "$line"
done
