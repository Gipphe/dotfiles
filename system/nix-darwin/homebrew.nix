{
  config,
  lib,
  flags,
  ...
}:
let
  hmConfig = config.home-manager.users.${flags.username}.config;
in
{
  homebrew = {
    enable = true;
    casks = lib.flatten [ (lib.optionals hmConfig.virtualization.docker.enable [ "docker" ]) ];
  };
}
