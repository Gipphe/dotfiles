{ pkgs, config, ... }:
let
  helpers = config.lib.nixvim;
  inherit (import ../util.nix) k;
in
{
  home.packages = [ pkgs.marp-cli ];
  programs.nixvim = {
    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        name = "marp-nvim";
        src = pkgs.fetchFromGitHub {
          owner = "aca";
          repo = "marp.nvim";
          rev = "58d9544d0fa2d78b538e2e2a9b4c018228af0bfe";
          hash = "sha256-aVQsE3aQRH0t7FRtOYlc4+sqcycpa0VBGrww2anEJmA=";
        };
      })
    ];

    keymaps = [
      (k "n" "<leader>mpo" "<cmd>lua require('marp.nvim').ServerStart()<cr>" {
        desc = "Start Marp server";
      })
      (k "n" "<leader>mpc" "<cmd>lua require('marp.nvim').ServerStop()<cr>" {
        desc = "Stop Marp server";
      })
    ];
    plugins.which-key.registrations = {
      "<leader>m" = "+marp";
    };

    autoGroups = {
      marp = {
        clear = true;
      };
    };
    autoCmd = [
      {
        event = "VimLeavePre";
        group = "marp";
        callback = helpers.mkRaw ''
          function()
            require('marp.nvim').ServerStop()
          end
        '';
      }
    ];
  };
}
