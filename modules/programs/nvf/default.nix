{ util, inputs, ... }:
util.mkProgram {
  name = "nvf";
  hm = {
    imports = [
      inputs.nvf.homeManagerModules.default
      ./formatter.nix
      ./languages.nix
      ./lsp.nix
      ./mini.nix
      ./navigation
      ./picker.nix
      ./theme.nix
      ./treesitter.nix
      ./ui.nix
    ];
    programs.nvf = {
      enable = true;
      settings = {
        vim = {
          syntaxHighlighting = true;
          undoFile = {
            enable = true;
          };
          useSystemClipboard = true;
          autocomplete.nvim-cmp = {
            enable = true;
          };
          binds = {
            cheatsheet.enable = true;
            whichKey.enable = true;
          };
          keymaps = [

            # Move lines
            {
              mode = "n";
              key = "<A-j>";
              action = "<cmd>m .+1<cr>==";
              desc = "Move down";
            }
            {
              mode = "n";
              key = "<A-k>";
              action = "<cmd>m .-2<cr>==";
              desc = "Move up";
            }
            {
              mode = "i";
              key = "<A-j>";
              action = "<esc><cmd>m .+1<cr>==gi";
              desc = "Move down";
            }
            {
              mode = "i";
              key = "<A-k>";
              action = "<esc><cmd>m .-2<cr>==gi";
              desc = "Move up";
            }
            {
              mode = "v";
              key = "<A-j>";
              action = ":m '>+1<cr>gv=gv";
              desc = "Move down";
            }
            {
              mode = "v";
              key = "<A-k>";
              action = ":m '<-2<cr>gv=gv";
              desc = "Move up";
            }

            # keywordprg
            {
              mode = "n";
              key = "<leader>K";
              action = "<cmd>norm! K<cr>";
              desc = "Keywordprg";
            }

            # better indenting
            {
              mode = "v";
              key = "<";
              action = "<gv";
            }
            {
              mode = "v";
              key = ">";
              action = ">gv";
            }

            # new file
            {
              mode = "n";
              key = "<leader>fn";
              action = "<cmd>enew<cr>";
              desc = "New File";
            }

            {
              mode = "n";
              key = "[q";
              action = "<cmd>lua vim.cmd.cprev<cr>";
              desc = "Previous Quickfix";
            }
            {
              mode = "n";
              key = "]q";
              action = "<cmd>lua vim.cmd.cnext<cr>";
              desc = "Next Quickfix";
            }
          ];
        };
      };
    };
  };
}
