{ util, ... }:
util.mkProfile {
  name = "tweag";
  shared.gipphe.tweag = {
    gh.enable = true;
    vcs.enable = true;
  };
}
