{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.gipphe.nixvim.haskell-tools;
in
{
  options.gipphe.nixvim.haskell-tools = {
    enable = lib.mkEnableOption "haskell-tools";
  };
  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      extraPackages = [ pkgs.vimPlugins.haskell-tools-nvim ];
      extraConfigLua = ''
        require('haskell-tools').setup({})
      '';
    };
  };
}
