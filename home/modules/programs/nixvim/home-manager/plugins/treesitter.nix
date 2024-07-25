{ config, ... }:
let
  inherit (import ../util.nix) k;
  inherit (config.nixvim) helpers;
in
{
  programs.nixvim = {
    plugins = {
      treesitter = {
        enable = true;
        folding = true;
        nixvimInjections = true;
        settings = {
          highlight.enable = true;
          indent.enable = true;
          incrementalSelection = {
            enable = true;
            keymaps = {
              initSelection = "<C-space>";
              nodeIncremental = "<C-space>";
              scopeIncremental = helpers.mkRaw "false";
              nodeDecremental = "<bs>";
            };
          };
        };
      };
      treesitter-context = {
        enable = true;
        settings = {
          mode = "cursor";
          maxLines = 3;
        };
      };
      treesitter-textobjects = {
        enable = true;
        move = {
          enable = true;
          gotoNextStart = {
            "]f" = "@function.outer";
            "]c" = "@class.outer";
            "]a" = "@parameter.inner";
          };
          gotoNextEnd = {
            "]F" = "@function.outer";
            "]C" = "@class.outer";
            "]A" = "@parameter.inner";
          };
          gotoPreviousStart = {
            "[f" = "@function.outer";
            "[c" = "@class.outer";
            "[a" = "@parameter.inner";
          };
          gotoPreviousEnd = {
            "[F" = "@function.outer";
            "[C" = "@class.outer";
            "[A" = "@parameter.inner";
          };
        };
      };
      treesitter-refactor = {
        enable = true;
        highlightCurrentScope.enable = true;
        highlightDefinitions.enable = true;
        highlightDefinitions.clearOnCursorMove = false;
        navigation = {
          enable = true;
          keymaps = {
            gotoDefinition = "gd";
            listDefinitions = "gD";
            gotoNextUsage = "<a-*>";
            gotoPreviousUsage = "<a-#>";
          };
        };
        smartRename = {
          enable = true;
          keymaps = {
            smartRename = "<leader>cr";
          };
        };
      };
      ts-context-commentstring = {
        enable = true;
        extraOptions = {
          enable_autocmd = false;
        };
      };
      ts-autotag.enable = true;
    };
    keymaps = [
      (k "n" "<leader>ut" "<cmd>TSContextToggle<cr>" { desc = "Toggle Treesitter context"; })
    ];
  };
}
