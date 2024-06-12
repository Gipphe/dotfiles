{ inputs, ... }:
{
  imports = [
    inputs.catppuccin.homeManagerModules.catppuccin

    ./audio
    ./cli
    ./core
    ./desktop
    ./services
    ./theme.nix
    ./work
    ./term.nix
  ];
}
