{ util, pkgs, ... }:
util.mkToggledModule [ "system" "thumbnails" ] {
  name = "video";
  system-nixos = {
    environment.systemPackages = builtins.attrValues {
      inherit (pkgs)
        ffmpeg-headless
        ffmpegthumbnailer
        webp-pixbuf-loader
        ;
    };
  };
}
