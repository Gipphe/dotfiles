{
  lib,
  config,
  hmConfig,
  ...
}:
{
  config = lib.mkIf (config.homebrew.enable && hmConfig.gipphe.virtualisation.docker.enable) {
    homebrew.casks = [ "docker" ];
  };
}
