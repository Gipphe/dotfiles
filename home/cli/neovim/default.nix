{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    ripgrep
    fzf
    fd
    # Required by treesitter
    gcc_multi
    libgcc
    # Required by terraformls LSP
    unzip
    gnutar
    curl
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
  ];
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    withNodeJs = true;
    withPython3 = true;
  };
  home.file = {
    ".config/nvim/after".source = ./after;
    ".config/nvim/lua".source = ./lua;
    ".config/nvim/lazyvim.json".source = ./lazyvim.json;
    ".config/nvim/stylua.toml".source = ./stylua.toml;
    ".config/nvim/init.lua".text = ''
      vim.g.lazy_lockfile = "${config.home.homeDirectory}/projects/dotfiles/home/cli/neovim/lazy-lock.json"

      -- bootstrap lazy.nvim, LazyVim and your plugins
      require("config.lazy")
    '';
  };
}
