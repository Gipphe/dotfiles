{ config, ... }:
let
  systems = {
    nixos-vm = ./nixos-vm.nix;
  };
in
{
  imports = systems.${config.gipphe.flags.hostname} or [ ];
}
