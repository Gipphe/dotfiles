{ lib, util, ... }:
util.mkModule {
  options.gipphe.core.wm.binds = lib.mkOption {
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
          action = lib.mkOption {
            description = "Action to perform when keybind is pressed";
            type = oneOf [
              (submodule {
                options.spawn = lib.mkOption {
                  type = str;
                  description = "Spawn a process or call a program.";
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
}
