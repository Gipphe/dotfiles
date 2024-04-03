{ ... }:
let
  inherit (import ../util.nix) k;
in
{
  programs.nixvim = {
    plugins.spectre = {
      enable = true;
      options = {
        open_cmd = "noswapfile vnew";
      };
    };
    keymaps = [
      (k "n" "<leader>sr" "<lua>require'spectre'.open()" { desc = "Replace in Files (Spectre)"; })
    ];
  };
}
