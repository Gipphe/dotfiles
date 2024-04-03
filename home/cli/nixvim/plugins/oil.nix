{ pkgs, ... }:
let
  inherit (import ../util.nix) k;
in
{
  programs.nixvim = {
    plugins.oil = {
      enable = true;
      settings = {
        columns = [ "icon" ];
        view_options = {
          show_hidden = true;
          is_always_hidden = ''
            function(name)
              return name == ".git" or name == ".jj"
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
