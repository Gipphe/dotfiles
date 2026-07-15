{ util, pkgs, ... }:
util.mkToggledModule [ "system" "thumbnails" ] {
  name = "image";
  nixos.environment.systemPackages = [
    # image/png; image/jpeg; image/bmp; image/x-bmp; image/x-MS-bmp; image/gif;
    # image/x-icon; image/x-ico; image/x-win-bitmap; image/vnd.microsoft.icon;
    # application/ico; image/ico; image/icon; text/ico;
    # image/x-portable-anymap; image/x-portable-bitmap;
    # image/x-portable-graymap; image/x-portable-pixmap; image/tiff;
    # image/x-xpixmap; image/x-xbitmap; image/x-tga; image/x-icns;
    # image/x-quicktime; image/qtif.
    pkgs.gdk-pixbuf
    (pkgs.writeTextDir "share/thumbnailers/custom-gdk-pixbuf" ''
      [Thumbnailer Entry]
      TryExec=gdk-pixbuf-thumbnailer
      Exec=gdk-pixbuf-thumbnailer -s %s %u %o
      MimeType=image/x-adobe-dng;image/x-dng;image/x-canon-cr2;image/x-canon-crw;image/x-cr2;image/x-crw;
    '')

    # image/heif; image/avif.
    # provides heif-thumbnailer (the program that generates HEIF thumbnails)
    pkgs.libheif.bin
    # provides heif.thumbnailer (allows for the viewing of HEIF thumbnails)
    pkgs.libheif.out

    # For JXL(JPEG XL) support
    pkgs.libjxl

    # For WebP support
    pkgs.webp-pixbuf-loader
  ];
}
