{ config, ... }:
let
  systems = {
    nixos-vm = ./nixos-vm.nix;
  };
in
{
  imports = systems.${config.networking.hostname} or [ ];
}
