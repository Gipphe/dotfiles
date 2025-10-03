{ util, ... }:
util.mkToggledModule [ "profiles" "nixos" ] {
  name = "thumbnails";
  shared.gipphe.system.thumbnails = {
    image.enable = true;
    video.enable = true;
  };
}
