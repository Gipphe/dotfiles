{ pkgs, ... }:
{
  programs.nixvim = {
    extraPlugins = [ pkgs.vimPlugins.neoconf-nvim ];
    extraConfigLua = "require('neoconf').setup()";
  };
}
