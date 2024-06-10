{
  lib,
  flags,
  config,
  ...
}:
let
  systems = {
    nixos-vm = ./nixos-vm.nix;
  };
in
lib.optionalAttrs flags.desktop.enable { imports = systems.${config.networking.hostname} or [ ]; }
