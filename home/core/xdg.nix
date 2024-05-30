{ pkgs, ... }:
{
  # Manage XDG directories and configs
  xdg.enable = true;
  home.packages = with pkgs; [ xdg-utils ];
}
