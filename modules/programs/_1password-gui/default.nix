{
  config,
  lib,
  pkgs,
  util,
  osConfig,
  ...
}:
let
  hmPkg = osConfig.programs._1password-gui.package;
  quick-access = lib.getExe (
    pkgs.writeShellScriptBin "1password-quick-access" ''
      ${hmPkg}/bin/1password --quick-access
    ''
  );
in
util.mkProgram {
  name = "_1password-gui";
  hm = {
    gipphe.core.wm.binds = [
      {
        mod = [
          "CTRL"
          "SHIFT"
        ];
        key = "space";
        action.spawn = quick-access;
      }
    ];

    gipphe.programs.hyprland.settings = {
      exec.onStartup = [ "1password --silent" ];
      windowRules = [
        {
          match.title = "Quick Access - 1Password";
          match.class = "1Password";
          float = true;
          stay_focused = true;
          allows_input = true;
        }
      ];
    };
  };

  # Allows the 1password browser extension to connect to the GUI app
  system-nixos = {
    programs._1password-gui = {
      enable = true;
      polkitPolicyOwners = [ config.gipphe.username ];
    };

    environment.etc."1password/custom_allowed_browsers" = {
      mode = "755";
      text = ''
        vivaldi-bin
        vivaldi
        floorp-bin
        floorp
        librewolf-bin
        librewolf
      '';
    };
  };
}
