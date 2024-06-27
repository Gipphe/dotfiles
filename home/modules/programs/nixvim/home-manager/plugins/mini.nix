{ config, ... }:
let
  inherit (import ../util.nix) kv;
  inherit (config.nixvim) helpers;
in
{
  programs.nixvim = {
    keymaps = [
      (kv "n" "<leader>up" ''
        function()
          vim.g.minipairs_disable = not vim.g.minipairs_disable
          if vim.g.minipairs_disable then
            print("Disabled auto pairs")
          else
            print("Enable auto pairs")
          end
        end
      '' { desc = "Toggle Auto Pairs"; })

      (kv "n" "<leader>bd" ''
        function()
          local bd = require('mini.bufremove').delete
          if vim.bo.modified then
            local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
            if choice == 1 then -- Yes
              vim.cmd.write()
              bd(0)
            elseif choice == 2 then
              bd(0, true)
            end
          else
            bd(0)
          end
        end
      '' { desc = "Delete buffer"; })
      (kv "n" "<leader>bD" "function() require('mini.bufremove').delete(0, true) end" {
        desc = "Delete buffer (force)";
      })
    ];
    plugins.mini = {
      enable = true;
      modules = {
        # Configured in `mini.ai.nix`
        # ai = {}
        bufremove = { };
        comment = {
          options = {
            custom_commentstring = helpers.mkRaw ''
              function()
                return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
              end
            '';
          };
        };
        indentscope = {
          symbol = "|";
          options = {
            try_as_border = true;
          };
        };
        pairs = { };
        surround = {
          mappings = {
            add = "gsa";
            delete = "gsd";
            find = "gsf";
            find_left = "gsF";
            highlight = "gsh";
            replace = "gsr";
            update_n_lines = "gsn";
          };
        };
      };
    };
    autoCmd = [
      {
        event = "FileType";
        pattern = [
          "help"
          "alpha"
          "dashboard"
          "neo-tree"
          "Trouble"
          "trouble"
          "lazy"
          "mason"
          "notify"
          "toggleterm"
          "lazyterm"
        ];
        callback = helpers.mkRaw ''
          function()
            vim.b.miniindentscope_disable = true
          end
        '';
      }
    ];
  };
}
