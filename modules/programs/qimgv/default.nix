{
  util,
  pkgs,
  lib,
  flags,

  ...
}:
let
  icon = "${pkgs.adwaita-icon-theme}/share/icons/Adwaita/16x16/mimetypes/image-x-generic.png";
in
util.mkProgram {
  name = "qimgv";
  hm = lib.optionalAttrs (!flags.isNixDarwin) {
    home.packages = [ pkgs.qimgv ];
    xdg.desktopEntries.qimgv = {
      exec = "${pkgs.qimgv}/bin/qimgv";
      name = "qimgv";
      inherit icon;
      type = "Application";
      mimeType = [
        "image/avif"
        "image/gif"
        "image/jpeg"
        "image/jpg"
        "image/png"
        "image/svg+xml"
        "image/webp"
      ];
    };
  };
}
