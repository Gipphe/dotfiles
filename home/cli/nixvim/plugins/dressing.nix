{ pkgs, ... }:
{
  programs.nixvim = {
    extraPlugins = [ pkgs.vimPlugins.dressing-nvim ];
    extraConfigLua = ''
      require('dressing').setup({})
    '';
  };
}
