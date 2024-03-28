{
  pkgs,
  lib,
  config,
  helpers,
  ...
}:
let
  cfg = config.gipphe.nixvim;
in
{
  options.gipphe.nixvim = {
    enable = lib.mkOption {
      default = !config.programs.neovim.enable;
      type = lib.types.bool;
    };

    is_wsl = lib.mkOption {
      default = builtins.getEnv "WSL_INTEROP" != "";
      type = lib.types.bool;
    };
  };
  config = lib.mkIf cfg.enable {
    imports = [ ./plugins ];
    programs.nixvim = {
      enable = true;
      colorscheme = "catppuccin";
      colorschemes.catppuccin = {
        enable = true;
        flavour = "mocha";
        showBufferEnd = true;
      };
      autoCmd =
        let
          fileMappings = {
            hurl = [ "*.hurl" ];
            sql = [ "*.sqlx" ];
            terraform = [
              "*.tf"
              "tf"
            ];
          };
          fileTypes = lib.attrsets.mapAttrsToList (ft: pattern: {
            inherit pattern;
            group = "file_mapping";
            callback = helpers.raw ''
              function(event)
                vim.b[event.buf].filetype = ${ft}
              end
            '';
          }) fileMappings;
        in
        [
          {
            event = "FileType";
            group = "nvim-metals";
            pattern = [
              "scala"
              "sbt"
              "java"
            ];
            callback = helpers.raw ''
              function()
                local metals = require('metals')
                local config = metals.bare_config()
                config.settings = {
                  showImplicitArguments = true,
                }
                config.init_options.statusBarProvider = "on"
                metals.initialize_or_attach(config)
              end
            '';
          }
        ]
        ++ fileTypes;
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
      keymaps =
        let
          k = mode: key: action: options: {
            inherit key action;
            options = {
              silent = true;
            } // options;
            mode = if builtins.isList mode then mode else [ mode ];
          };
        in
        [
          # better up/down
          (k
            [
              "n"
              "x"
            ]
            "j"
            "v:count == 0 ? 'gj' : 'j'"
            {
              expr = true;
              silent = true;
            }
          )
          (k
            [
              "n"
              "x"
            ]
            "<Down>"
            "v:count == 0 ? 'gj' : 'j'"
            {
              expr = true;
              silent = true;
            }
          )
          (k
            [
              "n"
              "x"
            ]
            "k"
            "v:count == 0 ? 'gk' : 'k'"
            {
              expr = true;
              silent = true;
            }
          )
          (k
            [
              "n"
              "x"
            ]
            "<Up>"
            "v:count == 0 ? 'gk' : 'k'"
            {
              expr = true;
              silent = true;
            }
          )

          # Move to window using the <ctrl> hjkl keys
          (k "n" "<C-h>" "<C-w>h" { desc = "Go to left window"; })
          (k "n" "<C-j>" "<C-w>j" { desc = "Go to lower window"; })
          (k "n" "<C-k>" "<C-w>k" { desc = "Go to upper window"; })
          (k "n" "<C-l>" "<C-w>l" { desc = "Go to right window"; })

          # Resize window using <ctrl> arrow keys
          (k "<C-Up>" "<cmd>resize +2<cr>" { desc = "Increase window height"; })
          (k "<C-Down>" "<cmd>resize -2<cr>" { desc = "Decrease window height"; })
          (k "<C-Left>" "<cmd>vertical resize -2<cr>" { desc = "Decrease window width"; })
          (k "<C-Right>" "<cmd>vertical resize +2<cr>" { desc = "Increase window width"; })

          # Move lines
          # TODO: add remaining keys from https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
        ];
    };
  };
}
