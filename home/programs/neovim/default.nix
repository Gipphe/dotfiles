{ pkgs, ... }: {
  home.packages = with pkgs; [
    ripgrep
    fzf
    fd
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
    tar
    curl
    libgcc
  ];
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    withNodeJs = true;
    withPython3 = true;
  };
  home.file.".config/nvim" = { source = ./.; };
}
