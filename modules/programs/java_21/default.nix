{
  util,
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.gipphe.programs.java_21;
in
util.mkProgram {
  name = "java_21";
  options.gipphe.programs.java_21.package = lib.mkPackageOption pkgs "java_21" { } // {
    default = pkgs.jdk;
  };
  hm.home = {
    packages = [ cfg.package ];
    sessionVariables.JAVA_HOME = "${cfg.package}/bin";
  };
}
