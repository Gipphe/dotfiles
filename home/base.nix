{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv) isDarwin;
in
{
  fonts.fontconfig.enable = lib.mkIf (!isDarwin) true;
  home = {
    stateVersion = "23.11"; # Please read the comment before changing.
    username = "gipphe";
    homeDirectory = lib.mkForce "/home/gipphe";
    sessionVariables.PAGER = "less -FXR";
    sessionVariables.FLAKE = "${config.home.homeDirectory}/projects/dotfiles";
  };
  programs.home-manager.enable = true;

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [ inputs.neovim-overlay.overlay ];
  };

  imports = [
    inputs.nix-index-db.hmModules.nix-index
    inputs.nixvim.homeManagerModules.nixvim
    ./cli
    ./services.nix
  ];
}
