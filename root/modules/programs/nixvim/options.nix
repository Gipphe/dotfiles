{ lib, ... }:
{
  options.gipphe.programs.nixvim = {
    enable = lib.mkEnableOption "nixvim";
    plugins.haskell = {
      enable = lib.mkEnableOption "haskell nixvim plugins";
      haskell-tools.enable = lib.mkEnableOption "haskell-tools nixvim plugin";
    };
  };
}
