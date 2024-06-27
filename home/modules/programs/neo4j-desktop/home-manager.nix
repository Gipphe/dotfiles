{
  lib,
  config,
  inputs,
  system,
  flags,
  ...
}:
{
  config = lib.mkIf (config.gipphe.programs.neo4j-desktop.enable && flags.isNixDarwin) {
    home.packages = [ inputs.brew-nix.packages.${system}.neo4j ];
  };
}
