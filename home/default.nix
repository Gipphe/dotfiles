{ inputs, ... }:
{
  imports = [
    inputs.barbie.homeManagerModule
    # inputs.impermanence.nixosModules.home-manager.impermanence
    inputs.hyprlock.homeManagerModules.default
    inputs.hypridle.homeManagerModules.default
    ./base.nix
    ./media.nix
    ./rice.nix
    # ./impermanence.nix
    ./packages.nix
  ];
}
