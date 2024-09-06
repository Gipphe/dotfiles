{ lib, config, ... }:
{
  config = lib.mkIf config.gipphe.programs.nixvim.plugins.haskell.enable {
    programs.nixvim.plugins.haskell-scope-highlighting.enable = true;
  };
}
