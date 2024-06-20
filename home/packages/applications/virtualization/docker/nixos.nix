{ lib, hmConfig, ... }:
{
  config = lib.mkIf (hmConfig.gipphe.virtualisation.docker.enable) {
    virtualisation.docker.enable = true;
  };
}
