{ lib, config, ... }:
{
  options.gipphe.profiles.programming.haskell.enable = lib.mkEnableOption "programming.haskell profile";
  config = lib.mkIf config.gipphe.profiles.programming.haskell.enable {
    gipphe.programs.nixvim.plugins.haskell.enable = true;
  };
}
