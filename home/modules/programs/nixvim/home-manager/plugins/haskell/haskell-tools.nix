{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
{
  options.gipphe.nixvim.plugins.haskell-tools.enable = lib.mkEnableOption "haskell-tools.nvim";
  config = lib.mkIf config.gipphe.nixvim.plugins.haskell-tools.enable {
    programs.nixvim = {
      extraPlugins = [ inputs.haskell-tools-nvim.packages.${pkgs.system}.default ];
    };
  };
}
