{ lib, ... }:
{
  options.gipphe.programs.neo4j-desktop.enable = lib.mkEnableOption "neo4j-desktop";
}
