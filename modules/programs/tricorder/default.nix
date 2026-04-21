{
  lib,
  pkgs,
  util,
  inputs,
  config,
  ...
}:
let
  cfg = config.gipphe.programs.tricorder;
in
util.mkProgram {
  name = "tricorder";
  hm = {
    options.gipphe.programs.tricorder = {
      package = lib.mkPackageOption pkgs "tricorder" { } // {
        default = inputs.tricorder.packages.${pkgs.stdenv.hostPlatform.system}.tricorder;
      };
    };
    config = {
      home.packages = [ cfg.package ];
    };
  };
}
