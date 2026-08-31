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
    bind = lib.mkOption {
      description = "Key bindings for the window manager";
      default = { };
      type =
        with lib.types;
        attrsOf (submodule {
          options = {
            action = {
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
            args = lib.mkOption {
              description = "Extra arguments passed to the compositor when registering the bind";
              type =
                with lib.types;
                submodule {
                  options = {
                    allow-when-locked = lib.mkOption {
                      type = bool;
                      default = false;
                      description = "Whether the keybind is available while the session is locked.";
                    };
                  };
                };
              default = { };
            };
          };
        });
    };
    triggers =
      let
        eventListener =
          with lib.types;
          submodule {
            options = {
              command = lib.mkOption {
                type = str;
                description = "Command to run on event";
              };
            };
          };
      in
      {
        on-startup = lib.mkOption {
          type = with lib.types; attrsOf eventListener;
          description = "Triggers to run on startup of the WM";
          default = { };
        };
        on-load = lib.mkOption {
          type = with lib.types; attrsOf eventListener;
          description = "Triggers to run for each reload of the WM configuration";
          default = { };
        };
      };
  };
}
