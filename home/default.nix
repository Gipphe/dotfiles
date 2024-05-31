{ inputs, ... }:
{
  imports = [
    inputs.catppuccin.homeManagerModules.catppuccin

    ./audio
    ./cli
    ./core
    ./desktop
    ./gui
    ./fonts.nix
    ./gaming.nix
    ./gui
    ./services
    ./theme
  ];
}
