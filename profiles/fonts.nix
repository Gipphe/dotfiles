{ util, ... }:
util.mkProfile {
  name = "fonts";
  shared.gipphe.core.fontconfig.enable = true;
}
