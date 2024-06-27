{ lib, ... }:
{
  options.gipphe.system.audio.enable = lib.mkEnableOption "audio";
}
