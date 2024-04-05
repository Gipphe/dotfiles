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
      function get_current_dir()
        local cwd = vim.fn.expand('%:p:h:~:.')
        return cwd:gsub("^oil://", "")
      end
    '';
    keymaps = [
      (k "n" "<leader>," "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>" {
        desc = "Switch buffer";
      })
      (kv "n" "<leader>/"
        "function() require('telescope.builtin').live_grep({ cwd = get_current_dir() }) end"
        { desc = "Grep (current dir)"; }
      )
      (k "n" "<leader>:" "<cmd>Telescope command_history<cr>" { desc = "Command history"; })
      (k "n" "<leader><space>" "<cmd>Telescope find_files<cr>" { desc = "Find files (cwd)"; })

      # find
      (k "n" "<leader>fb" "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>" {
        desc = "Buffers";
      })
      (kv "n" "<leader>ff" ''
        function()
          require('telescope.builtin').files({ cwd = get_current_dir() })
        end
      '' { desc = "Find files (current dir)"; })
      (k "n" "<leader>fF" "<cmd>Telescope find_files<cr>" { desc = "Find files (cwd)"; })
      (k "n" "<leader>fg" "<cmd>Telescope git_files<cr>" { desc = "Find files (git-files)"; })
      (kv "n" "<leader>fr" ''
        function()
          require('telescope.builtin').oldfiles({ cwd = get_current_dir() }) 
        end
      '' { desc = "Recent (current dir)"; })
      (kv "n" "<leader>fR" ''
        function()
          require('telescope.builtin').oldfiles({ cwd = vim.fn.getcwd() })
        end
      '' { desc = "Recent (cwd)"; })

      # git
      (k "n" "<leader>gc" "<cmd>Telescope git_commits<cr>" { desc = "Commits"; })
      (k "n" "<leader>gs" "<cmd>Telescope git_status<cr>" { desc = "Status"; })

      # search
      (k "n" "<leader>s\"" "<cmd>Telescope registers<cr>" { desc = "Registers"; })
      (k "n" "<leader>sa" "<cmd>Telescope autocommands<cr>" { desc = "Auto commands"; })
      (k "n" "<leader>sb" "<cmd>Telescope current_buffer_fuzzy_find<cr>" { desc = "Buffer"; })
      (k "n" "<leader>sc" "<cmd>Telescope command_history<cr>" { desc = "Command history"; })
      (k "n" "<leader>sC" "<cmd>Telescope commands<cr>" { desc = "Commands"; })
      (k "n" "<leader>sd" "<cmd>Telescope diagnostics bufnr=0<cr>" { desc = "Document diagnostics"; })
      (k "n" "<leader>sD" "<cmd>Telescope diagnostics<cr>" { desc = "Workspace diagnostics"; })
      (kv "n" "<leader>sg" ''
        function()
          require('telescope.builtin').live_grep({ cwd = get_current_dir() })
        end
      '' { desc = "Grep (current dir)"; })
      (k "n" "<leader>sG" "<cmd>Telescope live_grep<cr>" { desc = "Grep (cwd)"; })
      (k "n" "<leader>sh" "<cmd>Telescope help_tags<cr>" { desc = "Help pages"; })
      (k "n" "<leader>sH" "<cmd>Telescope highlights<cr>" { desc = "Search highlight groups"; })
      (k "n" "<leader>sk" "<cmd>Telescope keymaps<cr>" { desc = "Key maps"; })
      (k "n" "<leader>sM" "<cmd>Telescope man_pages<cr>" { desc = "Man pages"; })
      (k "n" "<leader>sm" "<cmd>Telescope marks<cr>" { desc = "Jump to mark"; })
      (k "n" "<leader>so" "<cmd>Telescope vim_options<cr>" { desc = "Options"; })
      (k "n" "<leader>sR" "<cmd>Telescope resume<cr>" { desc = "Resume"; })
      (kv "n" "<leader>sw" ''
        function()
          require('telescope.builtin').grep_string({ word_match = '-w', cwd = get_durrent_dir() })
        end
      '' { desc = "Word (current dir)"; })
      (kv "n" "<leader>sW" ''
        function()
          require('telescope.builtin').grep_string({ word_match = '-w' })
        end
      '' { desc = "Word (cwd)"; })
      (kv "v" "<leader>sw" ''
        function()
          require('telescope.builtin').grep_string({ cwd = get_current_dir() })
        end
      '' { desc = "Selection (current dir)"; })
      (k "v" "<leader>sW" "<cmd>Telescope grep_string<cr>" { desc = "Selection (cwd)"; })
      (kv "n" "<leader>uC" ''
        function()
          require('telescope.builtin').colorscheme({ enable_preview = true })
        end
      '' { desc = "Colorscheme with Preview"; })
    ];
  };
}
