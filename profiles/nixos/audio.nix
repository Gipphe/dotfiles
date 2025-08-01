{ util, ... }:
util.mkToggledModule [ "profiles" "nixos" ] {
  name = "audio";
  shared.gipphe.programs.pipewire.enable = true;
}
