{ config, ... }:
let
  flags = config.gipphe.flags;
in
{
  imports = [ ./xdg.nix ];
  # NO TOUCHY!
  home = {
    inherit (flags) username homeDirectory;
    stateVersion = "23.11";
    sessionVariables.FLAKE = "${config.home.homeDirectory}/projects/dotfiles";
  };

  # Manage home-manager executable
  programs.home-manager.enable = true;
}
