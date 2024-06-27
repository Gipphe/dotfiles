{ lib, config, ... }:
{
  options.gipphe.profiles.containers.enable = lib.mkEnableOption "containers profile";
  config = lib.mkIf config.gipphe.profiles.containers.enable {
    gipphe.virtualisation.docker.enable = true;
  };
}
