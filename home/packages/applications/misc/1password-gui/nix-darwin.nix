{
  lib,
  config,
  hmConfig,
  ...
}:
{
  config = lib.mkIf (config.homebrew.enable && hmConfig.gipphe.programs._1password.enable) {
    homebrew.casks = [ "1password" ];
  };
}
