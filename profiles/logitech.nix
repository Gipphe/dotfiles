{ util, ... }:
util.mkProfile "logitech" {
  gipphe = {
    programs = {
      logi-options-plus.enable = true;
      # Did not work as expected.
      # solaar.enable = true;
    };
    # Use ltunify to do things.
    system.devices.logitech.enable = true;
  };
}
