{
  lib,
  pkgs,
  util,
  ...
}:
util.mkProgram {
  name = "gpg";

  hm.config = lib.mkMerge [
    { programs.gpg.enable = true; }

    (lib.mkIf pkgs.stdenv.isLinux {
      services.gpg-agent = {
        enable = true;
        defaultCacheTtl = 1800;
        grabKeyboardAndMouse = false;
        pinentryPackage = pkgs.pinentry-curses;
      };
    })

    (lib.mkIf pkgs.stdenv.isDarwin {
      programs.fish.shellInit = ''
        set -gx GPG_TTY $(tty)
      '';

      home.file.".gnupg/gpg-agent.conf".text = ''
        default-cache-ttl 1800
        pinentry-program ${pkgs.pinentry-curses}/bin/pinentry
      '';
    })
  ];

  system-nixos.programs.gnupg.agent.enable = true;
}
