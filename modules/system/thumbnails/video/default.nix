{ util, pkgs, ... }:
util.mkToggledModule [ "system" "thumbnails" ] {
  name = "video";
  system-nixos = {
    environment.systemPackages = with pkgs; [
      ffmpeg-headless
      ffmpegthumbnailer
    ];
  };
}
