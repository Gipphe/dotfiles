{
  lib,
  config,
  pkgs,
  ...
}:
{
  # programs.nixvim = lib.mkIf config.programs.zellij.enable {
  #   extraPlugins = [ pkgs.vimPlugins.zellij-nvim ];
  #   extraConfigLua = ''
  #     require('zellij').setup({
  #       vimTmuxNavigatorKeybinds = true,
  #     })
  #   '';
  # };
}
