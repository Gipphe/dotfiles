{ lib, ... }:
{
  options.gipphe.programs.gh.enable = lib.mkEnableOption "gh";
}
