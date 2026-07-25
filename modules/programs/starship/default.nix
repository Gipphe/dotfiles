{
  lib,
  pkgs,
  util,
  ...
}:
util.mkProgram {
  name = "starship";
  homeManager = {
    programs.starship = {
      enable = true;
      enableTransience = true;
      settings = import ./preset.nix {
        inherit lib;
        inherit (pkgs) jujutsu fetchFromGitHub;
      };
    };
    stylix.targets.starship.enable = false;
  };
}
