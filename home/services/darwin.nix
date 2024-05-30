{ lib, pkgs, ... }:
{
  config = lib.mkIf pkgs.stdenv.isDarwin {
    programs.fish.shellInit = ''
      set -gx GPG_TTY $(tty)
    '';

    home.file.".gnupg/gpg-agent.conf".text = ''
      default-cache-ttl 1800
      pinentry-program ${pkgs.pinentry-curses}/bin/pinentry
    '';
  };
}
