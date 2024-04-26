{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.gipphe.services;
in
{
  options.gipphe.services.enable = lib.mkOption {
    default = !pkgs.stdenv.isDarwin;
    type = lib.types.bool;
  };
  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      services.gpg-agent = {
        enable = true;
        defaultCacheTtl = 1800;
        grabKeyboardAndMouse = false;
        pinentryPackage = pkgs.pinentry-curses;
        # enableSshSupport = true;
      };
    })
    (lib.mkIf (!cfg.enable) {
      programs.fish.shellInit = ''
        set -gx GPG_TTY $(tty)
      '';

      home.file.".gnupg/gpg-agent.conf".text = ''
        default-cache-ttl 1800
        pinentry-program ${pkgs.pinentry-curses}/bin/pinentry
      '';
    })
  ];
}
