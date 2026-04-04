{
  util,
  inputs,
  config,
  ...
}:
util.mkProgram {
  name = "btop";
  hm = {
    imports = [
      (inputs.wlib.lib.mkInstallModule {
        loc = [
          "home"
          "packages"
        ];
        name = "btop";
        value = inputs.wlib.lib.wrapperModules.btop;
      })
    ];
    wrappers.btop = {
      enable = true;
      settings = {
        color_theme = "stylix";
      };
      themes = {
        stylix = config.programs.btop.themes.stylix;
      };
    };
  };
}
