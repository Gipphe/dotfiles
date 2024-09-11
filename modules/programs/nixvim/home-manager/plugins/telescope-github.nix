{ pkgs, ... }:
let
  inherit (import ../util.nix) k;
in
{
  programs.nixvim = {
    extraPlugins = [ pkgs.vimPlugins.telescope-github-nvim ];
    extraConfigLua = ''
      require('telescope').load_extension('gh')
    '';
    keymaps = [
      (k "n" "<leader>tgi" "<cmd>Telescope gh issues<cr>" { desc = "Find GitHub issues (gh)"; })
      (k "n" "<leader>tgp" "<cmd>Telescope gh pull_request<cr>" {
        desc = "Find GitHub pull requests (gh)";
      })
      (k "n" "<leader>tgg" "<cmd>Telescope gh gist" { desc = "Find GitHub gists (gh)"; })
      (k "n" "<leader>tgw" "<cmd>Telescope gh run" { desc = "Find GitHub workflow runs (gh)"; })
    ];
  };
}
