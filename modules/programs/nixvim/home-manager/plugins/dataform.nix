{ pkgs, ... }:
let
  inherit (import ../util.nix) k;
in
{
  programs.nixvim = {
    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        name = "dataform.nvim";
        src = pkgs.fetchFromGitHub {
          owner = "magal1337";
          repo = "dataform.nvim";
          rev = "710d68381d089b891b1f60d41af10ab06cbd008d";
          hash = "sha256-EBvcGo0SJOuGEyjU0FhsJJyXR8TkN7WkM3jpZFyyZ6A=";
        };
      })
    ];
    plugins = {
      notify.enable = true;
      telescope.enable = true;
    };
    keymaps = [
      (k "n" "<leader>cpa" "<cmd>DataformRunAction<cr>" { desc = "Dataform run currently open action"; })
      (k "n" "<leader>cpd" "<cmd>DataformGoToRef<cr>" { desc = "Go to Dataform ref"; })
      (k "n" "<leader>cpb" "<cmd>DataformCompileFull<cr>" {
        desc = "Compile current Dataform file and view result";
      })
    ];
  };
}
