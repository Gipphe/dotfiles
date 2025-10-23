{ util, ... }:
util.mkProfile {
  name = "logitech";
  shared.gipphe = {
    programs = {
      solaar.enable = true;
    };
  };
}
