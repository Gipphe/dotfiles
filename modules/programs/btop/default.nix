{
  lib,
  util,
  inputs,
  config,
  pkgs,
  ...
}:
let
  module = inputs.wlib.wrappers.btop.eval {
    inherit pkgs;
    settings = {
      color_theme = "stylix";
    };
    themes = lib.mkIf config.gipphe.environment.stylix.enable {
      stylix = config.programs.btop.themes.stylix;
    };
  };
in
util.mkProgram {
  name = "btop";
  homeManager = {
    home.packages = [ module.config.wrapper ];
  };
}
