let
  inherit (import ../util.nix) kv;
in
{
  programs.nixvim = {
    plugins.flash = {
      enable = true;
    };
    keymaps = [
      (kv [
        "n"
        "x"
        "o"
      ] "s" "function() require('flash').jump() end" { desc = "Flash"; })
      (kv [
        "n"
        "x"
        "o"
      ] "S" "function() require('flash').treesitter() end" { desc = "Flash treesitter"; })
      (kv "o" "r" "function() require('flash').remote() end" { desc = "Remote flash"; })
      (kv [
        "o"
        "x"
      ] "R" "function() require('flash').treesitter_search() end" { desc = "Treesitter search"; })
      (kv "c" "<c-s>" "function() require('flash').toggle() end" { desc = "Toggle flash search"; })
    ];
  };
}
