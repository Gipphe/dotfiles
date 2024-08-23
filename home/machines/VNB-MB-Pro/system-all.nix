{ lib, config, ... }:
{
  config = lib.mkIf config.gipphe.machines.VNB-MB-Pro.enable {
    nix.settings.auto-optimise-store = lib.mkForce false;
  };
}
