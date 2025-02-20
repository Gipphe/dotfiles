let
  inherit (import ../mapping-prefixes.nix) session;
in
{
  imports = [
    ./buffers.nix
    ./oil.nix
  ];
  programs.nvf.settings.vim = {
    keymaps = [
      {
        mode = "n";
        key = "${session.prefix}q";
        action = "<cmd>quitall<cr>";
        desc = "Exit";
      }

      # Make j and k move up and down wrapped lines
      {
        mode = [
          "n"
          "x"
        ];
        key = "j";
        action = "v:count == 0 ? 'gj' : 'j'";
        expr = true;
        silent = true;
      }
      {
        mode = [
          "n"
          "x"
        ];
        key = "<Down>";
        action = "v:count == 0 ? 'gj' : 'j'";
        expr = true;
        silent = true;
      }
      {
        mode = [
          "n"
          "x"
        ];
        key = "k";
        action = "v:count == 0 ? 'gk' : 'k'";
        expr = true;
        silent = true;
      }
      {
        mode = [
          "n"
          "x"
        ];
        key = "<Up>";
        action = "v:count == 0 ? 'gk' : 'k'";
        expr = true;
        silent = true;
      }

      # Move to window using the <ctrl> hjkl keys
      {
        mode = "n";
        key = "<C-h>";
        action = "<C-w>h";
        desc = "Go to left window";
      }
      {
        mode = "n";
        key = "<C-j>";
        action = "<C-w>j";
        desc = "Go to lower window";
      }
      {
        mode = "n";
        key = "<C-k>";
        action = "<C-w>k";
        desc = "Go to upper window";
      }
      {
        mode = "n";
        key = "<C-l>";
        action = "<C-w>l";
        desc = "Go to right window";
      }

      # Resize window using <ctrl> arrow keys
      {
        mode = "n";
        key = "<C-Up>";
        action = "<cmd>resize +2<cr>";
        desc = "Increase window height";
      }
      {
        mode = "n";
        key = "<C-Down>";
        action = "<cmd>resize -2<cr>";
        desc = "Decrease window height";
      }
      {
        mode = "n";
        key = "<C-Left>";
        action = "<cmd>vertical resize -2<cr>";
        desc = "Decrease window width";
      }
      {
        mode = "n";
        key = "<C-Right>";
        action = "<cmd>vertical resize +2<cr>";
        desc = "Increase window width";
      }

      # Buffers
      {
        mode = "n";
        key = "<S-h>";
        action = "<cmd>bprevious<cr>";
        desc = "Prev buffer";
      }
      {
        mode = "n";
        key = "<S-l>";
        action = "<cmd>bnext<cr>";
        desc = "Next buffer";
      }
      {
        mode = "n";
        key = "[b";
        action = "<cmd>bprevious<cr>";
        desc = "Prev buffer";
      }
      {
        mode = "n";
        key = "]b";
        action = "<cmd>bnext<cr>";
        desc = "Next buffer";
      }
      {
        mode = "n";
        key = "<leader>bb";
        action = "<cmd>e #<cr>";
        desc = "Switch to other buffer";
      }
      {
        mode = "n";
        key = "<leader>`";
        action = "<cmd>e #<cr>";
        desc = "Switch to other buffer";
      }

      # Clear search with <esc>
      {
        mode = [
          "i"
          "n"
        ];
        key = "<esc>";
        action = "<cmd>noh<cr><esc>";
        desc = "Escape and clear hlsearch";
      }

      # Clear search, diff update and redraw
      # taken from runtime/lua/_editor.lua
      {
        mode = "n";
        key = "<leader>ur";
        action = "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>";
        desc = "Redraw / clear hlsearch / diff update";
      }

      # https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
      {
        mode = "n";
        key = "n";
        action = "'Nn'[v:searchforward].'zv'";
        expr = true;
        desc = "Next Search Result";
      }
      {
        mode = "x";
        key = "n";
        action = "'Nn'[v:searchforward]";
        expr = true;
        desc = "Next Search Result";
      }
      {
        mode = "o";
        key = "n";
        action = "'Nn'[v:searchforward]";
        expr = true;
        desc = "Next Search Result";
      }
      {
        mode = "n";
        key = "N";
        action = "'nN'[v:searchforward].'zv'";
        expr = true;
        desc = "Prev Search Result";
      }
      {
        mode = "x";
        key = "N";
        action = "'nN'[v:searchforward]";
        expr = true;
        desc = "Prev Search Result";
      }
      {
        mode = "o";
        key = "N";
        action = "'nN'[v:searchforward]";
        expr = true;
        desc = "Prev Search Result";
      }

      # Add undo break-points
      {
        mode = "i";
        key = ",";
        action = ",<c-g>u";
      }
      {
        mode = "i";
        key = ".";
        action = ".<c-g>u";
      }
      {
        mode = "i";
        key = ";";
        action = ";<c-g>u";
      }
    ];
  };
}
