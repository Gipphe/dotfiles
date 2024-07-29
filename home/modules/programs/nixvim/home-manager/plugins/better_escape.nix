{ config, ... }:
let
  nixvim = config.lib.nixvim;
in
{
  programs.nixvim.plugins.better-escape = {
    enable = true;
    settings = {
      timeout = 100;
      mappings =
        let
          escape = helpers.mkRaw ''
            function()
              return vim.api.nvim_win_get_cursor(0)[2] > 1 and '<ESC>l' or '<ESC>'
            end
          '';
          jk = {
            j.k = escape;
            k.j = escape;
          };
        in
        {
          i = jk;
          c = jk;
          t = jk;
          v = jk;
          s = jk;
        };
    };
  };
}
