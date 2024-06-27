{ lib, ... }:
{
  options.gipphe.programs.bat.enable = lib.mkEnableOption "bat";
}
