{
  inputs,
  config,
  lib,
  ...
}:
{
  config.nixpkgs.config.allowUnfree = true;
  config.fonts.fontconfig.enable = true;
  config.home = {
    stateVersion = "23.11"; # Please read the comment before changing.
    username = "gipphe";
    homeDirectory = lib.mkForce "/home/gipphe";
    sessionVariables.PAGER = "less -FXR";
    sessionVariables.FLAKE = "${config.home.homeDirectory}/projects/dotfiles";
  };
  config.programs.home-manager.enable = true;

  imports = [
    # inputs.nix-index-db.hmModules.nix-index
    # ./cli
    # ./services.nix
  ];
}
