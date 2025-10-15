{ util, ... }:
util.mkProfile {
  name = "tweag";
  shared.gipphe.tweag.vcs.enable = true;
}
