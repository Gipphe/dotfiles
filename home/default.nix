# { inputs, ... }:
{
  imports = [
    # inputs.barbie.homeManagerModule
    # inputs.impermanence.nixosModules.home-manager.impermanence
    # inputs.hyprlock.homeManagerModules.default
    # inputs.hypridle.homeManagerModules.default

    # ./impermanence.nix
    ./packages.nix

    ./hmOnly.nix
    ./rice
    # ./modules/desktop.nix
    ./scripts
    # ./misc
  ];
}
