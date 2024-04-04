{ config, ... }:
let
  inherit (config.nixvim) helpers;
in
{
  programs.nixvim = {
    autoGroups = {
      highlight_yank = {
        clear = true;
      };
      last_loc = {
        clear = true;
      };
      nvim-metals = {
        clear = true;
      };
    };
    autoCmd = [
      {
        event = "FileType";
        group = "nvim-metals";
        pattern = [
          "scala"
          "sbt"
          "java"
        ];
        callback = helpers.mkRaw ''
          function()
            local metals = require('metals')
            local config = metals.bare_config()
            config.settings = {
              showImplicitArguments = true,
            }
            config.init_options.statusBarProvider = "on"
            metals.initialize_or_attach(config)
          end
        '';
      }

      # Open buffer at last location
      {
        event = "BufReadPost";
        group = "last_loc";
        callback = helpers.mkRaw ''
          function(event)
            local exclude = { "gitcommit" }
            local buf = event.buf
            if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
              return
            end
            vim.b[buf].lazyvim_last_loc = true
            local mark = vim.api.nvim_buf_get_mark(buf, '"')
            local lcount = vim.api.nvim_buf_line_count(buf)
            if mark[1] > 0 and mark[1] <= lcount then
              pcall(vim.api.nvim_win_set_cursor, 0, mark)
            end
          end
        '';
      }

      # Highlight on yank
      {
        event = "TextYankPost";
        group = "highlight_yank";
        callback = helpers.mkRaw ''
          function()
            vim.hightlight.on_yank()
          end
        '';
      }
    ];
  };
}
