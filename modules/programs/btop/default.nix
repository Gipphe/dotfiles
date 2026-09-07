{
  lib,
  util,
  inputs,
  config,
  ...
}:
util.mkProgram {
  name = "btop";
  homeManager = {
    imports = [
      (inputs.wrappers.lib.getInstallModule {
        name = "btop";
        value = inputs.wrappers.lib.wrapperModules.btop;
      })
    ];
    wrappers.btop = {
      enable = true;
      settings = {
        color_theme = "stylix";
      };
      themes = lib.mkIf config.gipphe.environment.stylix.enable {
        stylix = config.programs.btop.themes.stylix;
      };
    };
  };
}
