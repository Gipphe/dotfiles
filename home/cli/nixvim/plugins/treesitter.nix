let
  inherit (import ../util.nix) k;
in
{
  programs.nixvim = {
    plugins = {
      treesitter = {
        enable = true;
        folding = true;
        indent = true;
        nixvimInjections = true;
        incrementalSelection = {
          enable = true;
          keymaps = {
            initSelection = "<C-space>";
            nodeIncremental = "<C-space";
            scopeIncremental = "<M-space>";
            nodeDecremental = "<bs>";
          };
        };
      };
      treesitter-context = {
        enable = true;
        maxLines = 3;
        mode = "cursor";
      };
      treesitter-textobjects.enable = true;
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
    };
    keymaps = [
      (k "n" "<leader>ut" "<cmd>TSContextToggle<cr>" { desc = "Toggle Treesitter context"; })
    ];
  };
}
