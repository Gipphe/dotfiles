{ util, ... }:
util.mkToggledModule [ "profiles" "gaming" ] {
  name = "streaming";
  shared.gipphe = {
    programs.sunshine.enable = true;
  };
}
