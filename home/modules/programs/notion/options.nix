{ lib, ... }:
{
  options.gipphe.programs.notion.enable = lib.mkEnableOption "notion";
}
