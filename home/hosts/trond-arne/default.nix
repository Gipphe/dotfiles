{ pkgs, ... }:
{
  imports = [ ../../packages/filen.nix ];
  home.packages = with pkgs; [ xdg-utils ];
}
