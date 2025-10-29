{ util, ... }:
util.mkProfile {
  name = "ai";
  shared.gipphe.programs = {
    claude-code.enable = true;
    mods.enable = true;
  };
}
