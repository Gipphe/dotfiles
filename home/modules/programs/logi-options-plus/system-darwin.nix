{ lib, config, ... }:
{
  config = lib.mkIf (config.homebrew.enable && config.gipphe.programs.logi-options-plus.enable) {
    homebrew.casks = [ "logi-options-plus" ];
  };
}
