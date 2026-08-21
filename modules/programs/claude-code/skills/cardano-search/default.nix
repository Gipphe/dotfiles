{
  util,
  lib,
  config,
  pkgs,
  ...
}:
let
  dir = pkgs.callPackage ./skill.nix { };
in
util.mkModule {
  homeManager.config = lib.mkIf config.gipphe.programs.claude-code.enable {
    gipphe.programs.claude-code.skills.cardano-search = dir;
  };
}
