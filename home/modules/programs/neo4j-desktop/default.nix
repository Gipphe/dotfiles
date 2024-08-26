{
  lib,
  flags,
  inputs,
  pkgs,
  util,
  ...
}:
util.mkProgram {
  name = "neo4j-desktop";
  hm = lib.mkIf flags.isNixDarwin {
    home.packages = [ inputs.brew-nix.packages.${pkgs.system}.neo4j ];
  };
}
