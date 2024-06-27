{
  lib,
  config,
  inputs,
  pkgs,
  flags,
  ...
}:
{
  config = lib.mkIf (config.gipphe.programs.neo4j-desktop.enable && flags.isNixDarwin) {
    home.packages = [ inputs.brew-nix.packages.${pkgs.system}.neo4j ];
  };
}
