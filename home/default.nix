{ inputs, ... }:
{
  imports = [
    ./base.nix
    ./media.nix
    inputs.barbie.homeManagerModule
    # inputs.impermanence.nixosModules.home-manager.impermanence
    inputs.hyprlock.homeManagerModules.default
    inputs.hypridle.homeManagerModules.default
  ];
}
