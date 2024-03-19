{ pkgs, system, hostname, ... }:
if hostname != "home-trond-arne" then
  { }
else {
  home.packages = with pkgs; [
    xdg-utils
    _1password-gui
    (import ../../home/packages/filen { inherit pkgs system; })
  ];
}
