{ config, pkgs, ... }:
{
  home = {
    inherit (config.gipphe) username homeDirectory;
    # NO TOUCHY!
    stateVersion = "23.11";
    sessionVariables = {
      FLAKE = "${config.home.homeDirectory}/projects/dotfiles";
      # Help dynamically linked libraries and other libraries depending upon the
      # c++ stdenv find their stuff
      LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib";
    };
  };

  # Manage home-manager executable
  programs.home-manager.enable = true;
}
