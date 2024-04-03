{ lib, ... }:
let
  files = lib.attrsets.foldlAttrs (
    l: k: v:
    l ++ (if v == "regular" && k != "default.nix" then [ k ] else [ ])
  ) [ ] (builtins.readDir ./.);
  imports = builtins.map (f: ./${f}) files;
in
{
  inherit imports;

  programs.nixvim.plugins = {
    copilot-lua.enable = true;
    haskell-scope-highlighting.enable = true;
    indent-blankline.enable = true;
    mini.enable = true;
    noice.enable = true;
    nvim-ufo.enable = true;
    sleuth.enable = true;
    tmux-navigator.enable = true;
    trouble.enable = true;
    ts-autotag.enable = true;
    undotree.enable = true;
    vim-css-color.enable = true;
    virt-column.enable = true;
    wilder.enable = true;
    wilder.modes = [
      "/"
      "?"
      ":"
    ];
  };
}
