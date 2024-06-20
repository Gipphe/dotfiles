{
  inputs,
  lib,
  flags,
  ...
}:
lib.optionalAttrs flags.system.isNixos {
  imports = [
    inputs.home-manager.nixosModules.default
    ./boot
    ./core
    ./desktop
    ./hardware-configuration
    ./nix.nix
    ./secrets.nix
    ./theme.nix
    ./user
    ./virtualbox.nix
    ./wsl.nix
    ../../home/nixos.nix
  ];
}
