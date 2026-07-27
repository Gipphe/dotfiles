{
  pkgs,
  util,
  lib,
  config,
  ...
}:
util.mkProgram {
  name = "kubectl";
  homeManager = {
    home.packages = lib.optional (!config.gipphe.programs.google-cloud-sdk.enable) [ pkgs.kubectl ];
    gipphe.core.shell.abbrs.k = "kubectl";
  };
}
