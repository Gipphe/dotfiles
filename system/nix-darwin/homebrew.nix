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
    casks = lib.flatten [
      (lib.optionals hmConfig.virtualization.docker.enable [ "docker" ])
      (lib.optionals hmConfig.programs.karabiner-elements.enable [ "karabiner-elements" ])
      (lib.optionals hmConfig.programs.logi-options-plus.enable [ "logi-options-plus" ])
      (lib.optionals hmConfig.programs.openvpn-connect.enable [ "openvpn-connect" ])
      (lib.optionals hmConfig.programs._1password.enable [ "1password" ])
    ];
  };
}
