{ config, ... }:
let
  helpers = config.lib.nixvim;
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
      json_conceal = {
        clear = true;
      };
      resize_splits = {
        clear = true;
      };
      checktime = {
        clear = true;
      };
      close_with_q = {
        clear = true;
      };
      man_unlisted = {
        clear = true;
      };
      wrap_spell = {
        clear = true;
      };
    };
    autoCmd = [
      # Close some windows with 'q'
      {
        event = "FileType";
        group = "close_with_q";
        pattern = [
          "PlenaryTestPopup"
          "help"
          "lspinfo"
          "notify"
          "qf"
          "query"
          "spectre_panel"
          "startuptime"
          "tsplayground"
          "neotest-output"
          "checkhealth"
          "neotest-summary"
          "neotest-output-panel"
        ];
        callback = helpers.mkRaw ''
          function(event)
            vim.bo[event.buf].buflisted = false
            vim.keymap.set("n", "q", "<cmd>close<cr>", {buffer = event.buf, silent = true})
          end
        '';
      }

      # Make inline man pages easier to close
      {
        event = "FileType";
        group = "man_unlisted";
        pattern = [ "man" ];
        callback = helpers.mkRaw ''
          function(event)
            vim.bo[event.buf].buflisted = false
          end
        '';
      }

      # Enable wrapping and spell check in text
      {
        event = "FileType";
        group = "wrap_spell";
        pattern = [
          "gitcommit"
          "markdown"
        ];
        callback = helpers.mkRaw ''
          function()
            vim.opt_local.wrap = true
            vim.opt_local.spell = true
          end
        '';
      }

      # Fix JSON conceallevel
      {
        event = "FileType";
        group = "json_conceal";
        pattern = [
          "json"
          "jsonc"
          "json5"
          "ndjson"
          "jsonl"
        ];
        callback = helpers.mkRaw ''
          function()
            vim.opt_local.conceallevel = 0
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

      # Resize splits if window resizes
      {
        event = "VimResized";
        group = "resize_splits";
        callback = helpers.mkRaw ''
          function()
            local current_tab = vim.fn.tabpagenr()
            vim.cmd("tabdo wincmd =")
            vim.cmd("tabnext " .. current_tab)
          end
        '';
      }

      # Highlight on yank
      {
        event = "TextYankPost";
        group = "highlight_yank";
        callback = helpers.mkRaw ''
          function()
            vim.highlight.on_yank()
          end
        '';
      }

      # Check if we need to reload the file when it changed
      {
        event = [
          "FocusGained"
          "TermClose"
          "TermLeave"
        ];
        group = "checktime";
        callback = helpers.mkRaw ''
          function()
            if vim.o.buftype ~= "nofile" then
              vim.cmd("checktime")
            end
          end
        '';
      }
    ];
  };
}
