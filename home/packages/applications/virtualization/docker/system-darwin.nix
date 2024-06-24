{ lib, config, ... }:
{
  config = lib.mkIf (config.homebrew.enable && config.gipphe.virtualisation.docker.enable) {
    homebrew.casks = [ "docker" ];
  };
}
