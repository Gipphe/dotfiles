{ util, ... }:
util.mkProfile {
  name = "thumbnails";
  shared.gipphe.system.thumbnails = {
    image.enable = true;
    video.enable = true;
  };
}
