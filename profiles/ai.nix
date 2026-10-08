{ util, ... }:
util.mkProfile {
  name = "ai";
  shared.gipphe.programs = {
    claude-code.enable = true;
    maki.enable = true;
  };
}
