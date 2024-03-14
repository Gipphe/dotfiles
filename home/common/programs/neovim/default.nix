{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ripgrep
    fzf
    fd
    # Required by treesitter
    libgcc
    gcc-unwrapped
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
    extraLuaConfig = ''
      vim.g.lazy_lockfile = "${builtins.toString ./.}/home/programs/neovim/lazy-lock.json"
    '';
  };
  home.file.".config/nvim" = {
    source = ./.;
  };
}
