{ lib, ... }:
let
  prefixes = import ./mapping-prefixes.nix;
in
{
  programs.nvf.settings.vim.binds = {
    cheatsheet.enable = true;
    whichKey.enable = true;
    whichKey.register = lib.pipe prefixes [
      builtins.attrNames
      (map (k: {
        name = prefixes.${k}.prefix;
        value = prefixes.${k}.description;
      }))
      builtins.listtoAttrs
    ];
  };
}
