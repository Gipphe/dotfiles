{ inputs, pkgs, ... }:
{
  home.packages = with pkgs; [
    inputs.nh.packages."x86_64-linux".default
    xdg-utils
  ];
  home.sessionVariables = {
    # Help dynamically linked libraries and other libraries depending upon the
    # c++ stdenv find their stuff
    LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib";
  };
}
