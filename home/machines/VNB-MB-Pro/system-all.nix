{ lib, config, ... }:
{
  config = lib.mkIf config.gipphe.machines.VNB-MB-Pro.enable {
    networking.hostName = "VNB-MB-Pro";
    nix.settings.auto-optimise-store = lib.mkForce false;
  };
}
