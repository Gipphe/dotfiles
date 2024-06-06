{
  inputs,
  lib,
  flags,
  ...
}:
lib.optionalAttrs (flags.system == "nixos") {
  imports = [
    inputs.home-manager.nixosModules.default
    ./boot
    ./core
    ./desktop
    ./hardware-configuration
    ./nix
    ./secrets
    ./theme
    ./user
    ./virtualbox
    ./wsl
  ];
}
