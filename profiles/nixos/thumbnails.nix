{ util, ... }:
util.mkToggledModule [ "profiles" "nixos" ] {
  name = "thumbnails";
  shared.gipphe = {
    programs.tumbler.enable = true;
    system.thumbnails = {
      image.enable = true;
      video.enable = true;
    };
  };
}
