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
  config = lib.mkIf hmConfig.gipphe.programs.homebrew.enable { homebrew.enable = true; };
}
