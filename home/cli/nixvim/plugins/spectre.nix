{ pkgs, ... }:
let
  inherit (import ../util.nix) kv;
in
{
  programs.nixvim = {
    extraPlugins = [ pkgs.vimPlugins.nvim-spectre ];
    extraConfigLua = "require('spectre').setup({ open_cmd = 'noswapfile vnew' })";
    keymaps = [
      (kv "n" "<leader>sr" "function() require('spectre').open() end" {
        desc = "Replace in Files (Spectre)";
      })
    ];
  };
}
