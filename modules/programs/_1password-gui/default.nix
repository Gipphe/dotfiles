{
  config,
  lib,
  pkgs,
  util,
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
    home.packages = with pkgs; [ _1password-gui ];

    wayland.windowManager.hyprland.settings = {
      bind = [
        "CTRL SHIFT,code:65,exec,${lib.getExe quick-access}"
      ];
      windowrule =
        let
          selector = "title:(Quick Access - 1Password), class:(1Password)";
        in
        [
          "float, ${selector}"
          "stayfocused, ${selector}"
          "allowsinput on, ${selector}"
        ];
    };

    systemd.user.services._1password = lib.mkIf config.gipphe.programs._1password-gui.startOnBoot {
      Unit = {
        Description = "Start 1password in silent mode on boot";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
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

  system-darwin.homebrew.casks = [ "1password" ];
}
