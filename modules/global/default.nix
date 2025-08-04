{
  util,
  lib,
  config,
  ...
}:
let
  opt =
    desc: actions:
    lib.mkOption {
      description = "Default ${desc}.";
      type =
        with lib.types;
        nullOr (submodule {
          options = {
            name = lib.mkOption {
              type = lib.types.str;
              description = "Name of the program.";
            };
            package = lib.mkOption {
              type = lib.types.package;
              description = "Package for the program.";
            };
            inherit actions;
          };
        });
      default = null;
    };
  scriptOpt =
    action:
    lib.mkOption {
      description = "Path to script used to ${action}.";
      type = with lib.types; either str path;
    };
  defaults = {
    browser = {
      open = scriptOpt "open browser";
    };
    filemanager = {
      open = scriptOpt "open";
    };
    lockscreen = {
      lock = scriptOpt "lock screen";
    };
    terminal = {
      open = scriptOpt "open";
    };
    pinentry = {
      open = scriptOpt "open";
    };
  };
in
util.mkModule {
  hm = {
    options.gipphe.default = lib.mapAttrs (name: actions: opt name actions) defaults;
    config = {
      home.sessionVariables = {
        BROWSER = lib.mkIf (
          config.gipphe.default.browser != null
        ) config.gipphe.default.browser.actions.open;
        TERMINAL = lib.mkIf (
          config.gipphe.default.terminal != null
        ) config.gipphe.default.terminal.actions.open;
      };
    };
  };
}
