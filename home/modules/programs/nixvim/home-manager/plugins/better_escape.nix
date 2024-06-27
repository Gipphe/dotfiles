{ config, ... }:
let
  inherit (config.nixvim) helpers;
in
{
  programs.nixvim.plugins.better-escape = {
    enable = true;
    clearEmptyLines = true;
    keys = helpers.mkRaw ''
      function()
        return vim.api.nvim_win_get_cursor(0)[2] > 1 and '<ESC>l' or '<ESC>'
      end
    '';
    timeout = 100;
    mapping = [
      "jk"
      "kj"
    ];
  };
}
