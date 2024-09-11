{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
{
  config = lib.mkIf config.gipphe.programs.nixvim.plugins.haskell.haskell-tools.enable {
    programs.nixvim = {
      extraPlugins = [ inputs.haskell-tools-nvim.packages.${pkgs.system}.default ];
    };
  };
}
