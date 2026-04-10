{ util, ... }:
util.mkToggledModule [ "profiles" "gaming" ] {
  name = "stream-host";
  shared.gipphe = {
    programs.sunshine.enable = true;
  };
}
