{ pkgs, ... }:
{
  imports = [
    ../../packages/filen.nix
    ../../modules/gaming.nix
  ];
  home.packages = with pkgs; [ xdg-utils ];
}
