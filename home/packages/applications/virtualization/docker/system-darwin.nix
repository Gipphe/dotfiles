{
  lib,
  config,
  flags,
  ...
}:
let
  hmConfig = config.home-manager.users.${flags.user.username};
in
{
  config = lib.mkIf (config.homebrew.enable && hmConfig.gipphe.virtualisation.docker.enable) {
    homebrew.casks = [ "docker" ];
  };
}
