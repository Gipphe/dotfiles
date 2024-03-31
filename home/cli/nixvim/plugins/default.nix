{ ... }:
{
  imports = [
    ./bufferline.nix
    ./cmp.nix
    ./conform.nix
    ./dressing.nix
    ./flash.nix
    ./haskell-tools.nix
    ./lint.nix
    ./lsp.nix
    ./lualine.nix
    ./luasnip.nix
    ./mini.nix
    ./navic.nix
    ./neoconf.nix
    ./neodev.nix
    ./notify.nix
    ./oil.nix
    ./telescope.nix
    ./todo-comments.nix
    ./treesitter.nix
    ./ts-context-commentstring.nix
    ./vim-matchup.nix
    ./which-key.nix
  ];
  programs.nixvim.plugins = {
    copilot-lua.enable = true;
    haskell-scope-highlighting.enable = true;
    indent-blankline.enable = true;
    mini.enable = true;
    noice.enable = true;
    nvim-ufo.enable = true;
    sleuth.enable = true;
    tmux-navigator.enable = true;
    trouble.enable = true;
    ts-autotag.enable = true;
    undotree.enable = true;
    vim-css-color.enable = true;
    virt-column.enable = true;
    wilder.enable = true;
    wilder.modes = [
      "/"
      "?"
      ":"
    ];
  };
}
