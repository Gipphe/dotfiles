{ pkgs, ... }: {
  home.packages = with pkgs; [
    ripgrep
    fzf
    fd
    tar
    curl
    libgcc
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
  ];
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    withNodeJs = true;
    withPython3 = true;
  };
  home.file.".config/nvim" = { source = ./.; };
}
