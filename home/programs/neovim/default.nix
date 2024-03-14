{ pkgs, config, lib, stdenv, ... }:
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
  };
  # home.file.".config/nvim" = { source = ./.; };
  # This is one way to create symlinks outside of the nix store.
  # systemd.user.tmpfiles.rules = [
  #   "L ${config.home.homeDirectory}/.config/nvim - - - - ${config.home.homeDirectory}/projects/dotfiles/home/programs/neovim"
  # ];
} // (if stdenv.isDarwin then {
  systemd.user.tmpfiles.rules = [
    "L ${config.home.homeDirectory}/.config/nvim - - - - ${config.home.homeDirectory}/projects/dotfiles/home/programs/neovim"
  ];
} else {
  programs.fish.shellInit = ''
    function __f {
      local s
      s="${config.home.homeDirectory}/.config/nvim"
      if ! test -s "$s"; then
        ln -s "$s" "${config.home.homeDirectory}/projects/dotfiles/home/programs/neovim"
      fi
    }
    __f
    unset __f
  '';
})
