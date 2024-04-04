{ ... }:
let
  inherit (import ../util.nix) k kv;
in
{
  programs.nixvim = {
    plugins.telescope = {
      enable = true;
      extensions = {
        fzf-native.enable = true;
      };
      defaults = {
        prompt_prefix = " ";
        selection_caret = " ";
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
    extraConfigLuaPre = ''
      function get_cwd()
        local cwd = vim.fn.expand('%:p:h:~:.')
        return cwd:gsub("^oil://", "")
      end
    '';
    keymaps = [
      (k "n" "<leader>," "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>" {
        desc = "Switch Buffer";
      })
      # (kv "n" "<leader>/" "LazyVim.telescope('live_grep')" { desc = "Grep (Root Dir)"; })
      (k "n" "<leader>:" "<cmd>Telescope command_history<cr>" { desc = "Command History"; })
      # (kv "n" "<leader><space>" "LazyVim.telescope('files')" { desc = "Find Files (Root Dir)"; })

      # find
      (k "n" "<leader>fb" "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>" {
        desc = "Buffers";
      })
      # (kv "n" "<leader>fc" "LazyVim.telescope.config_files()" { desc = "Find Config File"; })
      # (kv "n" "<leader>ff" "LazyVim.telescope('files')" { desc = "Find Files (Root Dir)"; })
      # (kv "n" "<leader>fF" "LazyVim.telescope('files' { cwd = false })" { desc = "Find Files (cwd)"; })
      (k "n" "<leader>fg" "<cmd>Telescope git_files<cr>" { desc = "Find Files (git-files)"; })
      (k "n" "<leader>fr" "<cmd>Telescope oldfiles<cr>" { desc = "Recent"; })
      (kv "n" "<leader>fR" "function() require('telescope').oldfiles({ cwd = get_cwd() }) end" {
        desc = "Recent (cwd)";
      })
      # (kv "n" "<leader>fR" LazyVim.telescope("oldfiles" { cwd = vim.uv.cwd() }) { desc = "Recent (cwd)"; })

      # git
      (k "n" "<leader>gc" "<cmd>Telescope git_commits<CR>" { desc = "Commits"; })
      (k "n" "<leader>gs" "<cmd>Telescope git_status<CR>" { desc = "Status"; })

      # search
      (k "n" "<leader>s\"" "<cmd>Telescope registers<cr>" { desc = "Registers"; })
      (k "n" "<leader>sa" "<cmd>Telescope autocommands<cr>" { desc = "Auto Commands"; })
      (k "n" "<leader>sb" "<cmd>Telescope current_buffer_fuzzy_find<cr>" { desc = "Buffer"; })
      (k "n" "<leader>sc" "<cmd>Telescope command_history<cr>" { desc = "Command History"; })
      (k "n" "<leader>sC" "<cmd>Telescope commands<cr>" { desc = "Commands"; })
      (k "n" "<leader>sd" "<cmd>Telescope diagnostics bufnr=0<cr>" { desc = "Document Diagnostics"; })
      (k "n" "<leader>sD" "<cmd>Telescope diagnostics<cr>" { desc = "Workspace Diagnostics"; })
      (kv "n" "<leader>sg" ''
        function()
          require('telescope.builtin').live_grep({ cwd = get_cwd() })
        end
      '' { desc = "Grep (current dir)"; })
      # (k "n" "<leader>sg" LazyVim.telescope("live_grep") {desc = "Grep (Root Dir)"; })
      (k "n" "<leader>sG" "<cmd>Telescope live_grep<cr>" { desc = "Grep (cwd)"; })
      # (k "n" "<leader>sG", LazyVim.telescope("live_grep" { cwd = false }) {desc = "Grep (cwd)"; })
      (k "n" "<leader>sh" "<cmd>Telescope help_tags<cr>" { desc = "Help Pages"; })
      (k "n" "<leader>sH" "<cmd>Telescope highlights<cr>" { desc = "Search Highlight Groups"; })
      (k "n" "<leader>sk" "<cmd>Telescope keymaps<cr>" { desc = "Key Maps"; })
      (k "n" "<leader>sM" "<cmd>Telescope man_pages<cr>" { desc = "Man Pages"; })
      (k "n" "<leader>sm" "<cmd>Telescope marks<cr>" { desc = "Jump to Mark"; })
      (k "n" "<leader>so" "<cmd>Telescope vim_options<cr>" { desc = "Options"; })
      (k "n" "<leader>sR" "<cmd>Telescope resume<cr>" { desc = "Resume"; })
      # (k "n" "<leader>sw" ''LazyVim.telescope("grep_string" { word_match = "-w" })'' {desc = "Word (Root Dir)"; })
      # (k "n" "<leader>sW" ''LazyVim.telescope("grep_string" { cwd = false, word_match = "-w" })'' {desc = "Word (cwd)"; })
      # (k "v" "<leader>sw" ''LazyVim.telescope("grep_string")'' {desc = "Selection (Root Dir)"; })
      # (k "v" "<leader>sW" ''LazyVim.telescope("grep_string" { cwd = false })'' {desc = "Selection (cwd)"; })
      # (k "n" "<leader>uC" ''LazyVim.telescope("colorscheme" { enable_preview = true })'' {desc = "Colorscheme with Preview"; })
    ];
  };
}
