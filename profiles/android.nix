{ util, ... }:
util.mkProfile {
  name = "android";
  shared.gipphe.environment.android.enable = true;
}
