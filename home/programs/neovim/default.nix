{ pkgs, config, ... }: {
  home.packages = with pkgs; [
    ripgrep
    fzf
    fd
    gnutar
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
  # home.file.".config/nvim" = { source = ./.; };
  # This is one way to create symlinks outside of the nix store.
  systemd.user.tmpfiles.rules = [
    "L ${config.home.homeDirectory}/.config/nvim - - - - ${config.home.homeDirectory}/projects/dotfiles/home/programs/neovim"
  ];
}
