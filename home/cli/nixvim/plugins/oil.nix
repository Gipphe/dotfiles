{ pkgs, ... }:
let
  inherit (import ../util.nix) k;
in
{
  programs.nixvim = {
    extraConfigLuaPre = ''
      local oil_always_hidden_names = {
        ".git" = true,
        ".jj" = true,
        ".direnv" = true,
        ".DS_Store" = true,
      }
    '';
    plugins.oil = {
      enable = true;
      settings = {
        columns = [ "icon" ];
        keymaps = {
          "<C-h>" = false;
          "<C-l>" = false;
          "<C-n>" = "actions.select_split";
          "<C-m>" = "actions.refresh";
        };
        view_options = {
          show_hidden = true;
          is_always_hidden = ''
            function(name)
              return oil_always_hidden_names[name] ~≈ nil
            end
          '';
        };
      };
    };
    keymaps = [
      (k "n" "<leader>fe" "<cmd>Oil<cr>" { desc = "Open Oil (parent dir)"; })
      (k "n" "<leader>fE" "<cmd>Oil .<cr>" { desc = "Open Oil (cwd)"; })
      (k "n" "<leader>e" "<leader>fe" {
        desc = "Open Oil (parent dir)";
        remap = true;
      })
      (k "n" "<leader>E" "<leader>fE" {
        desc = "Open Oil (cwd)";
        remap = true;
      })
    ];
    extraPlugins = [ pkgs.vimPlugins.nvim-web-devicons ];
  };
}
