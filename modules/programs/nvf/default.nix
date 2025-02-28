{
  util,
  inputs,
  pkgs,
  ...
}:
util.mkProgram {
  name = "nvf";
  hm = {
    imports = [
      inputs.nvf.homeManagerModules.default
      ./autocomplete.nix
      ./binds.nix
      ./formatter.nix
      ./languages.nix
      ./lsp.nix
      ./mini.nix
      ./navigation
      ./picker.nix
      ./session.nix
      ./theme.nix
      ./treesitter.nix
      ./ui.nix
      ./utility.nix
    ];
    programs.nvf = {
      enable = true;
      settings = {
        vim = {
          globals = {
            mapleader = " ";
            maplocalleader = "\\\\";
            root_spec = [
              "lsp"
              [
                ".git"
                "lua"
              ]
              "cwd"
            ];
            markdown_recommended_style = 0;
          };
          options = {
            autowrite = true;
            # Confirm to save changes before leaving modified buffer
            confirm = true;
            # Use spaces instead of tabs
            expandtab = true;
            # tcqj
            formatoptions = "jcroqlnt";
            grepformat = "%f:%l:%c:%m";
            # Use ripgrep for searching
            grepprg = "rg --vimgrep";
            ignorecase = true;
            # Preview incremental substitute
            inccommand = "nosplit";
            # Popup blend
            pumblend = 10;
            # Maximum number of entries in a popup
            pumheight = 10;
            # Lines of context
            scrolloff = 8;
            # Round indent
            shiftround = true;
            # Indent size
            shiftwidth = 2;
            # Columns of context
            sidescrolloff = 8;
            signcolumn = "yes";
            # Don't ignore case with capitals
            smartcase = true;
            # Insert indents automatically
            # Currently having issues where the closing bracket of a {} pair is
            # incorrectly idented.
            smartindent = true;
            autoindent = true;

            spellang = [ "en" ];
            timeoutlen = 300;
            # Put new windows below current
            splitkeep = "screen";
            tabstop = 2;
            # Allow cursor to move where there is no text in visual block mode
            virtualedit = "block";
            wildmode = "longest:full,full";
            winminwidth = 5;
            fillchars = {
              foldopen = "";
              foldclose = "";
              fold = " ";
              foldsep = " ";
              diff = "╱";
              eob = " ";
            };
            foldlevel = 99;
            foldtext = "v:lua.utils.foldtext()";
            shell = "${pkgs.bash}/bin/bash";
            updatetime = 50;
            colorcolumn = "80";
            wrap = true;
            linebreak = true;
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
          };
          syntaxHighlighting = true;
          undoFile = {
            enable = true;
          };
          useSystemClipboard = true;
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
