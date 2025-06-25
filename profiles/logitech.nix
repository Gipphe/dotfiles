{ util, ... }:
util.mkProfile "logitech" {
  gipphe.programs = {
    logi-options-plus.enable = true;
    solaar.enable = true;
  };
}
