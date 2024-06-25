{
  lib,
  config,
  pkgs,
  flags,
  ...
}:
{
  config = lib.mkIf config.gipphe.programs.gpg.enable (
    lib.mkMerge [
      (lib.mkIf flags.system.isNixos {
        programs.gpg.enable = true;
        services.gpg-agent = {
          enable = true;
          defaultCacheTtl = 1800;
          grabKeyboardAndMouse = false;
          pinentryPackage = pkgs.pinentry-curses;
        };
      })

      (lib.mkIf flags.system.isNixDarwin {
        programs.fish.shellInit = ''
          set -gx GPG_TTY $(tty)
        '';

        home.file.".gnupg/gpg-agent.conf".text = ''
          default-cache-ttl 1800
          pinentry-program ${pkgs.pinentry-curses}/bin/pinentry
        '';
      })
    ]
  );
}
