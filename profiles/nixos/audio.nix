{ util, ... }:
util.mkToggledModule [ "profiles" "nixos" ] {
  name = "audio";
  shared.gipphe.system.audio.enable = true;
}
