{ pkgs, ... }:
let
  inherit (import ../util.nix) k;
in
{
  programs.nixvim = {
    extraPlugins = [ pkgs.vimPlugins.nvim-spectre ];
    extraConfigLua = "require('spectre').setup({ open_cmd = 'noswapfile vnew' })";
    keymaps = [
      (k "n" "<leader>sr" "<lua>require'spectre'.open()" { desc = "Replace in Files (Spectre)"; })
    ];
  };
}
