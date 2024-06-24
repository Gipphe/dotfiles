{ lib, config, ... }:
{
  config = lib.mkIf (config.homebrew.enable && config.gipphe.programs._1password.enable) {
    homebrew.casks = [ "1password" ];
  };
}
