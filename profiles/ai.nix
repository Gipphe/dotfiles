{ util, ... }:
util.mkProfile {
  name = "ai";
  shared.gipphe.programs = {
    mods.enable = true;
  };
}
