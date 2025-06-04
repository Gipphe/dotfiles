{
  util,
  lib,
  config,
  ...
}:
util.mkModule {
  hm.config = lib.mkIf config.gipphe.environment.desktop.hyprland.enable {
    services.hyprpolkitagent.enable = true;
  };
}
