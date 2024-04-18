{ lib, ... }:
let
  inherit (import ../../../../util.nix { inherit lib; }) importSiblings;
in
{
  imports = builtins.map (x: ./${x}) (importSiblings ./.);

  programs.nixvim.plugins = {
    copilot-lua.enable = true;
    haskell-scope-highlighting.enable = true;
    indent-blankline.enable = true;
    navbuddy.enable = true;
    nvim-ufo.enable = true;
    sleuth.enable = true;
    tmux-navigator.enable = true;
    ts-autotag.enable = true;
    ts-context-commentstring = {
      enable = true;
      extraOptions = {
        enable_autocmd = false;
      };
    };
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
