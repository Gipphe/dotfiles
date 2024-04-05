{ ... }:
{
  programs.nixvim = {
    colorscheme = "catppuccin";
    colorschemes.catppuccin = {
      enable = true;
      flavour = "mocha";
      showBufferEnd = true;
      integrations = {
        illuminate.enabled = true;
        indent_blankline = {
          enabled = true;
          colored_indent_levels = true;
        };
        mini.enabled = true;
        navic.enabled = true;
        telescope.enabled = true;
        native_lsp.enabled = true;
        NormalNvim = true;
        cmp = true;
        flash = true;
        gitsigns = true;
        noice = true;
        notify = true;
        treesitter = true;
        treesitter_context = true;
        which_key = true;
      };
    };
  };
}
