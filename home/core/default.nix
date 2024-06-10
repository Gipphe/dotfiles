{
  config,
  flags,
  pkgs,
  ...
}:
{
  imports = [
    ./darwin
    ./fonts.nix
    ./xdg.nix
  ];
  # NO TOUCHY!
  home = {
    inherit (flags) username homeDirectory;
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
