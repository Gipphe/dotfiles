{ util, ... }:
util.mkProfile "ai" {
  gipphe.programs = {
    mods.enable = true;
  };
}
