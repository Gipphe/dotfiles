{ config, ... }:
let
  inherit (import ../util.nix) k;
  nixvim = config.lib.nixvim;
in
{
  programs.nixvim = {
    plugins.bufferline = {
      enable = true;
      closeCommand = helpers.mkRaw ''
        function(n)
          require('mini.bufremove').delete(n, false)
        end
      '';
      rightMouseCommand = helpers.mkRaw ''
        function(n)
          require('mini.bufremove').delete(n, false)
        end
      '';
      diagnostics = "nvim_lsp";
      alwaysShowBufferline = false;
      diagnosticsIndicator = ''
        function(_, _, diag)
          local ret = (diag.error and icons.diagnostics.Error .. diag.error .. " " or "")
            .. (diag.warning and icons.diagnostics.Warn .. diag.warning or "")
          return vim.trim(ret)
        end
      '';
    };
    keymaps = [
      (k "n" "<leader>bp" "<Cmd>BufferLineTogglePin<CR>" { desc = "Toggle Pin"; })
      (k "n" "<leader>bP" "<Cmd>BufferLineGroupClose ungrouped<CR>" {
        desc = "Delete Non-Pinned Buffers";
      })
      (k "n" "<leader>bo" "<Cmd>BufferLineCloseOthers<CR>" { desc = "Delete Other Buffers"; })
      (k "n" "<leader>br" "<Cmd>BufferLineCloseRight<CR>" { desc = "Delete Buffers to the Right"; })
      (k "n" "<leader>bl" "<Cmd>BufferLineCloseLeft<CR>" { desc = "Delete Buffers to the Left"; })
      (k "n" "<S-h>" "<cmd>BufferLineCyclePrev<cr>" { desc = "Prev Buffer"; })
      (k "n" "<S-l>" "<cmd>BufferLineCycleNext<cr>" { desc = "Next Buffer"; })
      (k "n" "[b" "<cmd>BufferLineCyclePrev<cr>" { desc = "Prev Buffer"; })
      (k "n" "]b" "<cmd>BufferLineCycleNext<cr>" { desc = "Next Buffer"; })
    ];
  };
}
