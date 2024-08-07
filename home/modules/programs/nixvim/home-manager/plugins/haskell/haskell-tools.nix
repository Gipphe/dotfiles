{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.gipphe.programs.nixvim.plugins.haskell;
in
{
  options.gipphe.programs.nixvim.plugins.haskell.haskell-tools.enable = lib.mkEnableOption "haskell-tools.nvim";
  config = lib.mkIf (cfg.enable && cfg.haskell-tools.enable) {
    programs.nixvim = {
      extraPlugins = [ inputs.haskell-tools-nvim.packages.${pkgs.system}.default ];
    };
  };
}
