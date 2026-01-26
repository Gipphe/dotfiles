{ lib, util, ... }:
util.mkModule {
  options.gipphe.core.wm = {
    actions = {
      monitors-off = lib.mkOption {
        type = lib.types.str;
        description = "Command to turn off all monitors";
      };
      monitors-on = lib.mkOption {
        type = lib.types.str;
        description = "Command to turn on all monitors";
      };
    };
    binds = lib.mkOption {
      type =
        with lib.types;
        listOf (submodule {
          options = {
            mod = lib.mkOption {
              type = either (listOf str) str;
              description = "Modifier keys for the key binding";
              default = [ ];
              example = [
                "Mod"
                "Alt"
              ];
            };
            key = lib.mkOption {
              type = str;
              description = "Key for the key binding";
              example = "T";
            };
            args = lib.mkOption {
              description = "Extra arguments passed to the compositor when registering the bind";
              type = with lib.types; attrsOf anything;
              default = { };
            };
            action = lib.mkOption {
              description = "Action to perform when keybind is pressed";
              type = oneOf [
                (submodule {
                  options = {
                    spawn = lib.mkOption {
                      type = nullOr str;
                      description = "Spawn a process or call a program.";
                      default = null;
                    };
                    shortcut = lib.mkOption {
                      type = nullOr str;
                      description = "Invoke a DBus global shortcut.";
                      default = null;
                    };
                  };
                })
              ];
            };
          };
        });
      default = [ ];
      description = ''
        WM-agnostic keybindings. Key codes are to be interpreted by the WM in question.
      '';
      example = [
        {
          mod = "Mod";
          keys = "Return";
          action.spawn = "wezterm";
        }
        {
          mod = [
            "Alt"
            "Shift"
          ];
          keys = "Tab";
          action.spawn = "...";
        }
      ];
    };
  };
}
