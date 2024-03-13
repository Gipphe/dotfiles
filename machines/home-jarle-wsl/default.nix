{ pkgs, hostname, ... }:
if hostname != "Jarle" then
  { }
else {
  home.packages = with pkgs; [ xdg-utils ];
}
