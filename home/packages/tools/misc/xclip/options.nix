{ lib, ... }:
{
  options.gipphe.programs.xclip.enable = lib.mkEnableOption "xclip";
}
