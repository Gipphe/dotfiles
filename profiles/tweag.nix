{ util, ... }:
util.mkProfile {
  name = "tweag";
  shared.gipphe = {
    programs.tricorder.enable = true;
    tweag.gh.enable = true;
    tweag.email.enable = true;
  };
}
