{ lib, config, ... }:
{
  config = lib.mkIf config.gipphe.virtualisation.docker.enable { homebrew.casks = [ "docker" ]; };
}
