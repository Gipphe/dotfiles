{ ... }:
{
  imports =
    let
      inherit (builtins) readDir filter attrNames;
      files = filter (n: n != "default.nix") (attrNames (readDir ./.));
    in
    map (f: ./${f}) files;
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
