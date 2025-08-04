{
  lib,
  pkgs,
  util,
  config,
  ...
}:
let
  inherit (pkgs.stdenv) hostPlatform;
in
util.mkProgram {
  name = "gpg";

  hm.config = lib.mkMerge [
    { programs.gpg.enable = true; }

    (lib.mkIf hostPlatform.isLinux {
      services.gpg-agent = {
        enable = true;
        defaultCacheTtl = 1800;
        grabKeyboardAndMouse = false;
        pinentry.program = config.gipphe.default.pinentry.name;
        pinentry.package = config.gipphe.default.pinentry.package;
      };
    })

    (lib.mkIf hostPlatform.isDarwin {
      programs.fish.shellInit = ''
        set -gx GPG_TTY $(tty)
      '';

      home.file.".gnupg/gpg-agent.conf".text = ''
        default-cache-ttl 1800
        pinentry-program ${config.gipphe.default.pinentry.package}
      '';
    })
  ];

  system-nixos.programs.gnupg.agent.enable = true;
}
