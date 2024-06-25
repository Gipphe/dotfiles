{ config, ... }:
let
  inherit (config.networking) hostname;
  systems = {
    nixos-vm = ./nixos-vm.nix;
  };
  imports = if builtins.hasAttr hostname systems then [ systems.${hostname} ] else [ ];
in
{
  inherit imports;
}
