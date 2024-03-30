{ pkgs, ... }:
{
  programs.nixvim = {
    extraPackages = [ pkgs.vimPlugins.haskell-tools-nvim ];
    extraConfigLua = ''
      require('haskell-tools').setup({})
    '';
  };
}
