{
  util,
  lib,
  config,
  ...
}:
util.mkProfile "desktop-darwin" {
  gipphe.programs = lib.mkIf config.gipphe.programs.firefox.enable {
    shortery.enable = true;
    velja.enable = true;
  };
}
