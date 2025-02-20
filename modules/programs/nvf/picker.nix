let
  inherit (import ./mapping-prefixes.nix) file;
in
{
  programs.nvf.settings.vim = {
    fzf-lua = {
      enable = true;
    };
    keymaps = [
      {
        mode = "n";
        key = "${file.prefix}f";
        action = "<cmd>FzfLua files<cr>";
        desc = "Find file";
      }
      {
        mode = "n";
        key = "${file.prefix}g";
        action = "<cmd>FzfLua live_grep<cr>";
        desc = "Find in files";
      }
      {
        mode = "n";
        key = "${file.prefix}b";
        action = "<cmd>FzfLua buffers<cr>";
        desc = "Find buffer";
      }
      {
        mode = "n";
        key = "${file.prefix}r";
        action = "<cmd>FzfLua resume<cr>";
        desc = "Resume last picker";
      }
    ];
  };
}
