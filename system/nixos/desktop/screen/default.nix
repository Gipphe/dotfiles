{ lib, flags, ... }:
let
  inherit (flags.system) hostname;
  systems = {
    nixos-vm = ./nixos-vm.nix;
  };
  imports = if systems ? hostname then [ systems.${hostname} ] else [ ];
in
lib.optionalAttrs flags.desktop.enable { inherit imports; }
