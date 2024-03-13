{ pkgs, hostname, ... }:
if hostname != "Jarle" then
  { }
else {
  home.packages = with pkgs; [ xdg-utils ];
  home.sessionVariables = {
    # Help dynamically linked libraries and other libraries depending upon the
    # c++ stdenv find their stuff
    LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib";
  };
}
