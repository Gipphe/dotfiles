{
  programs.nvf.settings.vim.treesitter = {
    enable = true;
    autotagHtml = true;
    context.enable = true;
    fold = true;
    highlight.enable = true;
    incrementalSelection.enable = true;
    indent.enable = true;
    mappings.incrementalSelection = {
      init = "<C-space>";
      incrementByNode = "<C-space>";
      incrementByScope = null;
      decrementByNode = "<bs>";
    };
  };
}
