{ lib, ... }:
{
  options.gipphe.programs.fzf.enable = lib.mkEnableOption "fzf";
}
