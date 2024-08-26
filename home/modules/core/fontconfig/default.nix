{ util, ... }:
util.mkToggledModule [ "core" ] {
  name = "fontconfig";
  hm.fonts.fontconfig.enable = true;
}
