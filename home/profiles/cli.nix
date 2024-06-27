{ lib, config, ... }:
{
  options.gipphe.profiles.cli.enable = lib.mkEnableOption "cli profile";
  config = lib.mkIf config.gipphe.profiles.cli.enable {
    gipphe.programs = {
      _1password.enable = true;
      bat.enable = true;
      curl.enable = true;
      direnv.enable = true;
      entr.enable = true;
      eza.enable = true;
      fastgron.enable = true;
      fd.enable = true;
      fish.enable = true;
      fzf.enable = true;
      gh.enable = true;
      git.enable = true;
      glab.enable = true;
      gpg.enable = true;
      imagemagick.enable = true;
      jq.enable = true;
      jujutsu.enable = true;
      less.enable = true;
      neovim.enable = false;
      nixvim.enable = true;
      nnn.enable = true;
      ripgrep.enable = true;
      gnused.enable = true;
      ssh.enable = true;
      gnutar.enable = true;
      thefuck.enable = true;
      tmux.enable = false;
      vim.enable = true;
      xclip.enable = true;
      zellij.enable = true;
      zoxide.enable = true;
    };
  };
}
