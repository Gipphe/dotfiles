{ ... }:
# let
#   inherit (import ../util.nix) k kv;
# in
{
  programs.nixvim = {
    plugins.telescope = {
      enable = true;
      extensions = {
        fzf-native.enable = true;
      };
      keymaps = {
        "<leader>ff" = {
          action = "git_files";
          desc = "Telescope git files";
        };
        "<leader>fg" = {
          action = "live_grep";
          desc = "Telescope live grep";
        };
      };
    };
    #   keymaps = [
    #     (k "n" "<leader>," "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>" { desc = "Switch Buffer"; })
    #     (kv "n" "<leader>/" "LazyVim.telescope('live_grep')" { desc = "Grep (Root Dir)"; })
    #     (k "n" "<leader>:" "<cmd>Telescope command_history<cr>" { desc = "Command History"; })
    #     (kv "n" "<leader><space>" "LazyVim.telescope('files')" { desc = "Find Files (Root Dir)"; })
    #     # find
    #     (k "n" "<leader>fb" "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>" { desc = "Buffers"; })
    #     (kv "n" "<leader>fc" "LazyVim.telescope.config_files()" { desc = "Find Config File"; })
    #     (kv "n" "<leader>ff" "LazyVim.telescope('files')" { desc = "Find Files (Root Dir)"; })
    #     (kv "n" "<leader>fF" "LazyVim.telescope('files' { cwd = false })" { desc = "Find Files (cwd)"; })
    #     (k "n" "<leader>fg" "<cmd>Telescope git_files<cr>" { desc = "Find Files (git-files)"; })
    #     (k "n" "<leader>fr" "<cmd>Telescope oldfiles<cr>" { desc = "Recent"; })
    #     (kv "n" "<leader>fR", LazyVim.telescope("oldfiles" { cwd = vim.uv.cwd() }) { desc = "Recent (cwd)"; })
    #     # git
    #     "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "Commits" },
    #     "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "Status" },
    #     # search
    #     '<leader>s"', "<cmd>Telescope registers<cr>", desc = "Registers" },
    #     "<leader>sa", "<cmd>Telescope autocommands<cr>", desc = "Auto Commands" },
    #     "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer" },
    #     "<leader>sc", "<cmd>Telescope command_history<cr>", desc = "Command History" },
    #     "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands" },
    #     "<leader>sd", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Document Diagnostics" },
    #     "<leader>sD", "<cmd>Telescope diagnostics<cr>", desc = "Workspace Diagnostics" },
    #     "<leader>sg", LazyVim.telescope("live_grep"), desc = "Grep (Root Dir)" },
    #     "<leader>sG", LazyVim.telescope("live_grep", { cwd = false }), desc = "Grep (cwd)" },
    #     "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
    #     "<leader>sH", "<cmd>Telescope highlights<cr>", desc = "Search Highlight Groups" },
    #     "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" },
    #     "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
    #     "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Jump to Mark" },
    #     "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "Options" },
    #     "<leader>sR", "<cmd>Telescope resume<cr>", desc = "Resume" },
    #     "<leader>sw", LazyVim.telescope("grep_string", { word_match = "-w" }), desc = "Word (Root Dir)" },
    #     "<leader>sW", LazyVim.telescope("grep_string", { cwd = false, word_match = "-w" }), desc = "Word (cwd)" },
    #     "<leader>sw", LazyVim.telescope("grep_string"), mode = "v", desc = "Selection (Root Dir)" },
    #     "<leader>sW", LazyVim.telescope("grep_string", { cwd = false }), mode = "v", desc = "Selection (cwd)" },
    #     "<leader>uC", LazyVim.telescope("colorscheme", { enable_preview = true }), desc = "Colorscheme with Preview" },    };
    #
    # ];
  };
}
