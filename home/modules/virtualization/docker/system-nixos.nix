{ lib, config, ... }:
{
  config = lib.mkIf config.gipphe.virtualisation.docker.enable {
    virtualisation.docker.enable = true;
  };
}
