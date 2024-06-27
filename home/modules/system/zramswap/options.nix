{ lib, ... }:
{
  options.gipphe.system.zramswap.enable = lib.mkEnableOption "zramswap";
}
