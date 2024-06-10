{ inputs, ... }:
{
  imports = [
    inputs.catppuccin.homeManagerModules.catppuccin

    ./audio
    ./cli
    ./core
    ./desktop
    ./services
    ./theme
    ./work
  ];
}
