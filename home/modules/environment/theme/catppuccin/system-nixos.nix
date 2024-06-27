{ inputs, ... }:
{
  imports = [
    inputs.catppuccin.nixosModules.catppuccin
    ./shared.nix
  ];
}
