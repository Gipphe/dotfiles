{
  lib,
  config,
  inputs,
  system,
  flags,
  ...
}:
{
  options.gipphe.programs.neo4j-desktop.enable = lib.mkEnableOption "neo4j-desktop";
  config = lib.mkIf (config.gipphe.programs.neo4j-desktop.enable && flags.system.isNixDarwin) {
    home.packages = [ inputs.brew-nix.packages.${system}.neo4j ];
  };
}
