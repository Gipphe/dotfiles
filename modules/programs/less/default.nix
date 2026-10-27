{
  config,
  lib,
  pkgs,
  util,
  ...
}:
util.mkProgram {
  name = "less";
  homeManager = {
    options.gipphe.programs.less.package = lib.mkPackageOption pkgs "less" { };
    programs.less = {
      enable = true;
      package = config.gipphe.programs.less.package;
    };
    home.sessionVariables.PAGER = "less -FXR";
  };
}
