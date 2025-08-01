{ util, ... }:
util.mkProfile {
  name = "logitech";
  shared.gipphe = {
    programs = {
      logi-options-plus.enable = true;
      solaar.enable = true;
    };
  };
}
