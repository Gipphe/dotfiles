{ lib, config, ... }:
{
  config = lib.mkIf config.gipphe.machines.VNB-MB-Pro.enable { networking.hostName = "VNB-MB-Pro"; };
}
