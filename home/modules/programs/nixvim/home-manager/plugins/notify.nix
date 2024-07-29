{ config, ... }:
let
  inherit (import ../util.nix) kv;
  nixvim = config.lib.nixvim;
in
{
  programs.nixvim = {
    plugins.notify = {
      enable = true;
      timeout = 3000;
      stages = "static";
      maxHeight = helpers.mkRaw ''
        function()
          return math.floor(vim.o.lines * 0.75)
        end
      '';
      maxWidth = helpers.mkRaw ''
        function()
          return math.floor(vim.o.columns * 0.75)
        end
      '';
      onOpen = ''
        function(win)
          vim.api.nvim_win_set_config(win, { zindex = 100 })
        end
      '';
    };
    keymaps = [
      (kv "n" "<leader>un" "function() require('notify').dismiss({ silent = true, pending = true }) end" {
        desc = "Dismiss all notifications";
      })
    ];
  };
}
