{
  lib,
  config,
  hmConfig,
  ...
}:
{
  config = lib.mkIf (config.homebrew.enable && hmConfig.gipphe.programs.logi-options-plus.enable) {
    homebrew.casks = [ "logi-options-plus" ];
  };
}
