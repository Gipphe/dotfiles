{
  lib,
  pkgs,
  helpers,
  config,
  ...
}:
let
  cfg = config.gipphe.nixvim;
in
{
  programs.nixvim = {

    globals = {
      editorconfig = true;
      clipboard = lib.mkIf cfg.is_wsl {
        name = "WslClipboard";
        copy = {
          "+" = "clip.exe";
          "*" = "clip.exe";
        };
        paste = {
          "+" = ''sowershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))'';
          "*" = ''powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))'';
        };
        cache_enabled = 0;
      };
    };
    options = {
      shell = "${pkgs.bash}/bin/bash -i";
      scrolloff = 8;
      updatetime = 50;
      colorcolumn = "80";
      wrap = true;
      title = true;
      titlestring = "%t %h%m%r%w (%{v:progname})";
      list = true;
      conceallevel = 0;
      listchars = {
        tab = ">-";
        trail = "~";
        extends = ">";
        precedes = "<";
      };
      completeopt = [
        "menuone"
        "preview"
        "noinsert"
        "noselect"
      ];

      # Optimal for undotree
      swapfile = false;
      backup = false;
      undodir = helpers.raw ''os.getenv("HOME") .. "/.vim/undodir"'';
      undofile = true;
    };
  };
}
