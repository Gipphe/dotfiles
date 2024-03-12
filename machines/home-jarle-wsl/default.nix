{ pkgs, hostname, ... }:
if hostname != "home-wsl-jarle" then
  { }
else {
  home.packages = with pkgs; [ xdg-utils ];
}
