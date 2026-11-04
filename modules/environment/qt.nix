{
  den.aspects.environment.qt = {
    homeManager = { pkgs, config, ... }: {
      qt = {
        enable = true;
        style.name = "kvantum";
        platformTheme.name = "qtct";
        qt5ctSettings = {
          Appearance = {
            custom_palette = true;
            standard_dialogs = "default";
            style = "kvantum";
          };
        };
        qt6ctSettings = config.qt.qt5ctSettings;
        kvantum = {
          enable = true;
          settings.General.theme = "catppuccin-macchiato-sapphire";
          themes = [ pkgs.catppuccin-kvantum ];
        };
      };
    };
    nixos = {
      qt = {
        enable = true;
        style = "kvantum";
        platformTheme = "qt5ct";
      };
    };
  };
}
