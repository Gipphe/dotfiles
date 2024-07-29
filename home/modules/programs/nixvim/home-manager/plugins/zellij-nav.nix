{ pkgs, ... }:
let
  inherit (import ../util.nix) k;
in
{
  programs.nixvim = {
    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        name = "zellij-nav.nvim";
        src = pkgs.fetchFromGitHub {
          owner = "swaits";
          repo = "zellij-nav.nvim";
          rev = "25930804397ef540bd2de62f9897bc2db61f9baa";
          hash = "sha256-TUhA6UGwpZuYWDU4j430LMnHVD8cggwrAzQ+HlT5ox8=";
        };
      })
    ];
    extraConfigLua = ''
      require('zellij-nav').setup()
    '';
    keymaps = [
      (k "n" "<C-h>" "<cmd>ZellijNavigateLeft<cr>" { desc = "Navigate left"; })
      (k "n" "<C-l>" "<cmd>ZellijNavigateRight<cr>" { desc = "Navigate right"; })
      (k "n" "<C-j>" "<cmd>ZellijNavigateDown<cr>" { desc = "Navigate down"; })
      (k "n" "<C-k>" "<cmd>ZellijNavigateUp<cr>" { desc = "Navigate up"; })
    ];
  };
}
