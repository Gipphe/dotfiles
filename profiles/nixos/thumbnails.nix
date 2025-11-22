{ util, ... }:
util.mkToggledModule [ "profiles" "nixos" ] {
  name = "thumbnails";
  shared.gipphe = {
    programs.tumbler.enable = true;
    system.thumbnails = {
      document.enable = true;
      image.enable = true;
      video.enable = true;
    };
  };
}
