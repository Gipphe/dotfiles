{
  util,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.gipphe.programs.wayprompt.pinentry.default;
in
util.mkProgram {
  name = "wayprompt";
  options.gipphe.programs.wayprompt = {
    package = lib.mkPackageOption pkgs "wayprompt" { } // {
      default = config.programs.wayprompt.package;
    };
    pinentry.default = lib.mkEnableOption "default pinentry program" // {
      default = true;
    };
  };
  hm = {
    programs.wayprompt = {
      enable = true;
    };
    gipphe.default.pinentry = {
      name = "pinentry-wayprompt";
      inherit (config.programs.wayprompt) package;
      actions.open = "${cfg.package}/pinentry-wayprompt";
    };
  };
}
