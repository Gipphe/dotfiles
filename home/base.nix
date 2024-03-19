{ inputs, config, ... }:
{
  config.nixpkgs.config.allowUnfree = true;
  config.fonts.fontconfig.enable = true;
  config.home = {
    stateVersion = "23.11"; # Please read the comment before changing.
    username = "gipphe";
    homeDirectory = "/home/gipphe";
    sessionVariables.PAGER = "less -FXR";
  };
  config.programs.home-manager.enable = true;

  imports = [
    inputs.nix-index-db.hmModules.nix-index
    ./packages
    ./programs
  ];
}
