{
  lib,
  util,
  config,
  ...
}:
let
  inherit (import ./utils.nix) removeNullAttrs;
  cfg = config.gipphe.programs.hyprland;
  toLua = lib.generators.toLua { };
  toPermission = permission: "hl.permission(${toLua (removeNullAttrs permission)})";
in
util.mkModule {
  options.gipphe.programs.hyprland.settings.permissions = lib.mkOption {
    description = ''
      Permissions granted to specific programs

      Note:

      **xdg-desktop-portal** implementations (including xdph) are just regular
      applications. They will go through permissions too. You might want to
      consider adding a rule like this:

      ```
      {
        binary = "''${lib.escapeRegex "''${pkgs.xdg-desktop-portal-hyprland}"}";
        type = "screencopy";
        mode = "allow";
      }
      ```
    '';
    default = [ ];
    example = [
      {
        binary = "/usr/bin/grim";
        type = "screencopy";
        mode = "allow";
      }
      {
        binary = "/usr/bin/appsuite-.*";
        type = "screencopy";
        mode = "allow";
      }
    ];
    type =
      with lib.types;
      listOf (submodule {
        options = {
          binary = lib.mkOption {
            description = ''
              Path to the binary to match on. This is a regex string, so caution must be had when using paths that contain special regex characters (e.g. `+`). To use NixOS binaries, either match with a regular expression or interpolate the path to the binary, ensuring to escape any regular expression characters.
            '';
            example = lib.literalExpression ''
              "''${lib.escapeRegex (lib.getExe config.programs.hyprlock.package)}"
            '';
            type = str;
          };
          type = lib.mkOption {
            description = ''
              The type of permission to grant/deny/require approval for.

              Permission list

              `screencopy`:

              - Default: **ASK**
              - Access to your screen without going through
                xdg-desktop-portal-hyprland. Examples include: `grim`,
                `wl-screenrec`, `wf-recorder`.
              - If denied, will render a black screen with a "permission
                denied" text.
              - Why deny? For apps / scripts that might maliciously try to
                capture your screen without your knowledge by using wayland
                protocols directly.

              `plugin`:

              - Default: **ASK**
              - Access to load a plugin. Can be either a regex for the app
                binary, or plugin path.
              - Do not allow `hyprctl` to load your plugins by default
                (attacker could issue `hyprctl plugin load
                /tmp/my-malicious-plugin.so`) - use either `deny` to disable or
                `ask` to be prompted.

              `keyboard`:

              - Default: **ALLOW**
              - Access to connecting a new keyboard. Regex of the device name.
              - If you want to disable all keyboards not matching a regex, make
                a rule that sets `DENY` for `.*` _as the last keyboard
                permission rule_.
              - Why deny? Rubber duckies, malicious virtual / usb keyboards.

              `cursorpos`:

              - Default: **ASK**
              - Access to your cursor position and cursor image via Wayland
                protocols directly.
              - Why deny? Prevents apps from silently tracking where your
                cursor is without going through xdg-desktop-portal.
            '';
            type = enum [
              "screencopy"
              "plugin"
              "keyboard"
              "cursorpos"
            ];
          };
          mode = lib.mkOption {
            description = ''
              Permission mode to apply

              There are 3 modes:

              - `allow`: Don’t ask, just allow the app to proceed.
              - `ask`: Pop up a notification every time the app tries to do
                something sensitive. These popups allow you to Deny, Allow until
                the app exits, or Allow until Hyprland exits.
              - `deny`: Don’t ask, always deny the application access.
            '';
            type = enum [
              "allow"
              "ask"
              "deny"
            ];
          };
        };
      });
  };

  hm = {
    gipphe.programs.hyprland.settings.rendered = lib.mkIf (cfg.settings.permissions != [ ]) (
      builtins.concatStringsSep "\n" (map toPermission cfg.settings.permissions)
    );
  };
}
