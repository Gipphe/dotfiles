{ pkgs, ... }:
{
  programs.nixvim = {
    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        name = "zellij.vim";
        src = pkgs.fetchFromGitHub {
          owner = "fresh2dev";
          repo = "zellij.vim";
          rev = "0.3.0";
          hash = "";
        };
      })
    ];

    globals.zellij_navigator_move_focus_or_tab = 1;
  };
}
