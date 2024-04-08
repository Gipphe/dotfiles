let
  inherit (import ../util.nix) kv;
in
{
  programs.nixvim = {
    plugins.persistence = {
      enable = true;
      options = [
        "buffers"
        "curdir"
        "tabpages"
        # "winsizes"
        "help"
        "globals"
        "skiprtp"
        "folds"
      ];
    };

    keymaps = [
      (kv "n" "<leader>qs" ''function() require("persistence").load() end'' { desc = "Restore Session"; })
      (kv "n" "<leader>ql" ''function() require("persistence").load({ last = true }) end'' {
        desc = "Restore Last Session";
      })
      (kv "n" "<leader>qd" ''function() require("persistence").stop() end'' {
        desc = "Don't Save Current Session";
      })
    ];
  };
}
