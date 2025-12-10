{
  config,
  lib,
  pkgs,
  util,
  flags,
  ...
}:
let
  quick-access = pkgs.writeShellScriptBin "1password-quick-access" ''
    ${pkgs._1password-gui}/bin/1password --quick-access
  '';
in
util.mkProgram {
  name = "_1password-gui";
  options.gipphe.programs._1password-gui.startOnBoot =
    lib.mkEnableOption "start 1password on boot"
    // {
      default = pkgs.stdenv.hostPlatform.isLinux;
    };

  hm = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
    home.packages = [ pkgs._1password-gui ];

    gipphe.core.wm.binds = [
      {
        mod = [
          "CTRL"
          "SHIFT"
        ];
        key = "space";
        action.spawn = lib.getExe quick-access;
      }
    ];
    wayland.windowManager.hyprland.settings.windowrule = [
      "float true, stay_focused true, allows_input true, match:title (Quick Access - 1Password), match:class (1Password)"
    ];

    systemd.user.services._1password = lib.mkIf config.gipphe.programs._1password-gui.startOnBoot {
      Unit = {
        Description = "Start 1password in silent mode on boot";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
        X-Reload-Triggers = lib.optional flags.isNixos "/etc/1password/custom_allowed_browsers";
      };
      Service = {
        ExecStart = "${pkgs.writeShellScriptBin "1password-boot" ''
          ${pkgs._1password-gui}/bin/1password --silent
        ''}/bin/1password-boot";
        Restart = "never";
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };
  };

  # Allows the 1password browser extension to connect to the GUI app
  system-nixos.environment.etc."1password/custom_allowed_browsers" = {
    user = "root";
    group = "root";
    mode = "755";
    text = ''
      vivaldi-bin
      floorp-bin
    '';
  };
}
