{ lib, config, ... }:
{
  options.gipphe.profiles.virtualisation.containers.enable = lib.mkEnableOption "virtualization.containers";
  config = lib.mkIf config.gipphe.profiles.virtualisation.containers.enable {
    gipphe.virtualisation.docker.enable = true;
  };
}
