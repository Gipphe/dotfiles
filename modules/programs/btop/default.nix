{
  lib,
  util,
  inputs,
  config,
  ...
}:
util.mkProgram {
  name = "btop";
  home-manager = {
    imports = [
      (inputs.wlib.lib.getInstallModule {
        name = "btop";
        value = inputs.wlib.lib.wrapperModules.btop;
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
