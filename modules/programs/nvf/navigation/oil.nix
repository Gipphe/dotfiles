{ pkgs, ... }:
{
  programs.nvf.settings.vim = {
    extraPlugins = {
      "oil-nvim" = {
        package = pkgs.vimPlugins.oil-nvim;
        setup = # lua
          ''
            local oil_always_hidden_names = {
              [".git"] = true,
              [".jj"] = true,
              [".direnv"] = true,
              [".DS_Store"] = true,
            }
            require('oil').setup({
              columns = { "icon" },
              keymaps = {
                ["<C-h>"] = false,
                ["<C-l>"] = false,
                ["<C-n>"] = "actions.select_split",
                ["<C-m>"] = "actions.refresh",
              },
              view_options = {
                show_hidden = true,
                is_always_hidden = function(name)
                  return oil_always_hidden_names[name] ~= nil
                end,
              },
            })
          '';
      };
    };
    keymaps = [
      {
        mode = "n";
        key = "<leader>e";
        action = "<cmd>Oil<cr>";
        desc = "Open Oil (parent dir)";
      }
      {
        mode = "n";
        key = "<leader>E";
        action = "<cmd>Oil .<cr>";
        desc = "Open Oil (cwd)";
      }
    ];
  };
}
