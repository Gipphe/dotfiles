{
  inputs,
  config,
  lib,
  pkgs,
  ...
}@args:
let
  inherit (pkgs.stdenv) isDarwin;
  username = args.username or "gipphe";
  homeDirectory = args.homeDirectory or "/home/gipphe";
in
{
  fonts.fontconfig.enable = lib.mkIf (!isDarwin) true;
  home = {
    inherit username;
    stateVersion = "23.11"; # Please read the comment before changing.
    homeDirectory = lib.mkForce homeDirectory;
    sessionVariables.PAGER = "less -FXR";
    sessionVariables.FLAKE = "${config.home.homeDirectory}/projects/dotfiles";
  };
  programs.home-manager.enable = true;

  imports = [
    inputs.nix-index-db.hmModules.nix-index
    inputs.nixvim.homeManagerModules.nixvim
    ./cli
    ./services.nix
  ];
}
