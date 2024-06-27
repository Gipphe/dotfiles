{
  pkgs,
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.gipphe.programs.neovim.enable {
    home.packages = with pkgs; [
      ripgrep
      fzf
      fd
      # Required by Marksman LSP
      icu
      # Required by treesitter
      gcc_multi
      libgcc
      # Required by terraformls LSP
      unzip
      gnutar
      curl
      # Required by nil LSP
      cargo
      (nerdfonts.override { fonts = [ "FiraCode" ]; })
    ];
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      withNodeJs = true;
      withPython3 = true;
      extraLuaConfig = ''
        vim.g.lazy_lockfile = "${config.home.homeDirectory}/projects/dotfiles/home/cli/neovim/lazy-lock.json"
        vim.opt.shell = "${pkgs.bash}/bin/bash -i"

        -- bootstrap lazy.nvim, LazyVim and your plugins
        require("config.lazy")
      '';
    };
    home.file = {
      ".config/nvim/after".source = ./after;
      ".config/nvim/lua".source = ./lua;
      ".config/nvim/lazyvim.json".source = ./lazyvim.json;
      ".config/nvim/stylua.toml".source = ./stylua.toml;
    };
  };
}
