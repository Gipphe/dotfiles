{ lib, ... }:
{
  options.gipphe.system.nvidia.enable = lib.mkEnableOption "nvidia drivers";
}
