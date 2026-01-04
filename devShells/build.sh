#!/usr/bin/env bash

command="$1"
ask="${2-}"
if test -n "$ask"; then
  ask="--ask"
fi

if command -v nixos-rebuild &>/dev/null; then
  nh os "$command" "$ask"
  if test "$?" != 0; then
    exit 1
  fi
elif command -v nix-on-droid &>/dev/null; then
  host="$(jq -r '.hostname' env.json)"
  if test -z "$host"; then
    echo 'Found no hostname in env.json' >&2
    exit 1
  fi

  nix-on-droid build --flake "$(pwd)#$host"

  echo
  nixOnDroidPkg="$(nix path-info --impure "$NH_FLAKE#nixOnDroidConfigurations.$host.activationPackage")"
  nvd diff "$nixOnDroidPkg" result
  echo

  REPLY=
  if test -n "$ask"; then
    echo "Apply the config?"
    read -r -p "[y/N]" -n 1 REPLY
    echo
  else
    REPLY=y
  fi

  case "${REPLY,,}" in
  y)
    nix-on-droid switch --flake "$(pwd)#""$host"
    ;;
  esac
  rm -f result
else
  echo "This is not a NixOS or nix-on-droid system" >&2
  exit 1
fi
