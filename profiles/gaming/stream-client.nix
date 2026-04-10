{ util, ... }:
util.mkToggledModule [ "profiles" "gaming" ] {
  name = "stream-client";
  shared.gipphe.programs.moonlight-qt.enable = true;
}
