{ lib, ... }:
{
  options.gipphe.programs.git.enable = lib.mkEnableOption "git";
}
