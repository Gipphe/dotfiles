{
  den.aspects.system.thumbnails.video.nixos = { pkgs, ... }: {
    environment.systemPackages = builtins.attrValues {
      inherit (pkgs)
        ffmpeg-headless
        ffmpegthumbnailer
        webp-pixbuf-loader
        ;
    };
  };
}
