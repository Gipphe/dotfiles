{ lib, config, ... }:
{
  config = lib.mkIf (config.homebrew.enable && config.gipphe.programs.karabiner-elements.enable) {
    homebrew.casks = [ "karabiner-elements" ];
  };
}
