{ util, ... }:
util.mkProfile "desktop-darwin" {
  gipphe.programs = {
    shortery.enable = true;
    velja.enable = true;
  };
}
