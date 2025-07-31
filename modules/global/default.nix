{ util, lib, ... }:
let
  opt =
    desc: actions:
    lib.mkOption {
      description = "Default ${desc}.";
      type =
        with lib.types;
        submodule {
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
        };
    };
  scriptOpt =
    action:
    lib.mkOption {
      description = "Path to script used to ${action}.";
      type = with lib.types; either str path;
    };
  defaults = {
    "browser" = {
      open = scriptOpt "open browser";
    };
    "filemanager" = {
      open = scriptOpt "open";
    };
    "lockscreen" = {
      lock = scriptOpt "lock screen";
    };
  };
in
util.mkModule {
  options.gipphe.default = lib.mapAttrs (name: actions: opt name actions) defaults;
}
