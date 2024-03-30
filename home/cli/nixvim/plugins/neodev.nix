{ pkgs, ... }:
{
  programs.nixvim = {
    extraPlugins = [ pkgs.vimPlugins.neodev-nvim ];
    extraConfigLua = "require('neodev').setup({})";
  };
}
