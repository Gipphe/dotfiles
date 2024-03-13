{ pkgs, hostname, ... }:
if hostname != "Jarle" then
  { }
else {
  home.packages = with pkgs; [ xdg-utils ];
  home.sessionVariables = {
    LD_LIBRARY_PATH = "$LD_LIBRARY_PATH:/usr/lib/x86_64-linux-gnu";
  };
}
