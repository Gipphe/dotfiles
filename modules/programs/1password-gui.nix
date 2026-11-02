{ den, ... }:
{
  den.aspects.programs._1password-gui = {
    includes = [ (den.batteries.unfree [ "1password" ]) ];
    homeManager =
      {
        osConfig,
        pkgs,
        lib,
        ...
      }:
      {
        wayland.windowManager.hyprland.settings.window_rule = [
          {
            match.title = "Quick Access - 1Password";
            match.class = "1Password";
            float = true;
            stay_focused = true;
            allows_input = true;
          }
        ];
        gipphe.core.wm = {
          triggers.on-startup._1password.command = "1password --silent";
          bind =
            let
              pkg = osConfig.programs._1password-gui.package;
              quick-access = lib.getExe (
                pkgs.writeShellScriptBin "1password-quick-access" ''
                  ${pkg}/bin/1password --quick-access
                ''
              );
            in
            {
              "CTRL + SHIFT + space".action.spawn = quick-access;
            };
        };
      };

    # Allows the 1password browser extension to connect to the GUI app
    nixos = { user }: {
      programs._1password-gui = {
        enable = true;
        polkitPolicyOwners = [ user.userName ];
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
          zen
          zen-bin
        '';
      };
    };
  };
}
