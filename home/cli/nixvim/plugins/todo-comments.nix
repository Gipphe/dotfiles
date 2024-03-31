{ ... }:
let
  inherit (import ../util.nix) k kv;
in
{
  programs.nixvim = {
    plugins.todo-comments = {
      enable = true;
    };
    keymaps = [
      (kv "n" "]t" "function() require('todo-comments').jump_next() end" { desc = "Next todo comment"; })
      (kv "n" "[t" "function() require('todo-comments').jump_prev() end" {
        desc = "Previous todo comment";
      })
      (k "n" "<leader>xt" "<cmd>TodoTrouble<cr>" { desc = "Todo (Trouble)"; })
      (k "n" "<leader>xT" "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>" {
        desc = "Todo/Fix/Fixme (Trouble)";
      })
      (k "n" "<leader>st" "<cmd>TodoTelescope<cr>" { desc = "Todo"; })
      (k "n" "<leader>sT" "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>" { desc = "Todo/Fix/Fixme"; })
    ];
  };
}
