{ lib, pkgs, ... }:
let
  inherit (import ./mapping-prefixes.nix) file;
in
{
  programs.nvf.settings.vim = {
    lazy.plugins = {
      undotree = {
        package = pkgs.vimPlugins.undotree;
        setupModule = "undotree";
        setupOpts = { };
        keys = [
          {
            mode = "n";
            key = "${file.prefix}u";
            action = "<cmd>UndotreeToggle<cr><cmd>UndotreeFocus<cr>";
            desc = "Toggle Undotree";
          }
        ];
      };
    };

    options = {
      # Optimal for undotree
      swapfile = false;
      backup = false;
      undodir =
        lib.generators.mkLuaInline # lua
          ''os.getenv("HOME") .. "/.vim/undodir"'';
      undofile = true;
      undolevels = 10000;
    };
  };
}
