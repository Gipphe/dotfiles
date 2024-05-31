{ inputs, ... }:
{
  imports = [
    inputs.agenix.nixosModules.age
    inputs.catppuccin.nixosModules.catppuccin
    # inputs.nh.nixosModules.default

    ./boot
    ./core
    ./desktop
    # ./hardware-configuration
    # ./nix
    # ./secrets
    # ./theme
    # ./user
    # ./virtualbox
    # ./wsl
  ];
}
