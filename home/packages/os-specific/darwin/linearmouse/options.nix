{ lib, ... }:
{
  options.gipphe.programs.linearmouse.enable = lib.mkEnableOption "linearmouse";
}
