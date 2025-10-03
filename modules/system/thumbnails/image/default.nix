{ util, pkgs, ... }:
util.mkToggledModule [ "system" "thumbnails" ] {
  name = "image";
  system-nixos.environment.systemPackages = with pkgs; [
    # image/png; image/jpeg; image/bmp; image/x-bmp; image/x-MS-bmp; image/gif;
    # image/x-icon; image/x-ico; image/x-win-bitmap; image/vnd.microsoft.icon;
    # application/ico; image/ico; image/icon; text/ico;
    # image/x-portable-anymap; image/x-portable-bitmap;
    # image/x-portable-graymap; image/x-portable-pixmap; image/tiff;
    # image/x-xpixmap; image/x-xbitmap; image/x-tga; image/x-icns;
    # image/x-quicktime; image/qtif.
    gdk-pixbuf
    (writeTextDir "share/thumbnailers/custom-gdk-pixbuf" ''
      [Thumbnailer Entry]
      TryExec=gdk-pixbuf-thumbnailer
      Exec=gdk-pixbuf-thumbnailer -s %s %u %o
      MimeType=image/x-adobe-dng;image/x-dng;image/x-canon-cr2;image/x-canon-crw;image/x-cr2;image/x-crw;
    '')

    # image/heif; image/avif.
    libheif
    libheif.out

    # image/x-canon-cr2;image/x-canon-crw;image/x-minolta-mrw;image/x-nikon-nef;image/x-pentax-pef;image/x-panasonic-rw2;image/x-panasonic-raw2;image/x-samsung-srw;image/x-olympus-orf;image/x-sony-arw
    nufraw
    nufraw-thumbnailer
    (writeTextDir "share/thumbnailers/custom-nufraw.thumbnailer" ''
      [Thumbnailer Entry]
      TryExec=nufraw-batch
      Exec=nufraw-batch --silent --size %s --out-type=png --output=%o %i
      MimeType=image/x-adobe-dnb;image/x-dng;
    '')
  ];
}
