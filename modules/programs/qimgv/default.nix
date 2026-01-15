{
  util,
  pkgs,
  lib,
  ...
}:
let
  icon = "${pkgs.adwaita-icon-theme}/share/icons/Adwaita/16x16/mimetypes/image-x-generic.png";
  mimeTypes = [
    "image/avif"
    "image/gif"
    "image/jpeg"
    "image/jpg"
    "image/png"
    "image/svg+xml"
    "image/webp"
  ];
in
util.mkProgram {
  name = "qimgv";
  hm = {
    home.packages = [ pkgs.qimgv ];
    xdg = {
      mimeApps.defaultApplications = lib.genAttrs mimeTypes (_: [ "qimgv.desktop" ]);
      desktopEntries.qimgv = {
        exec = "${pkgs.qimgv}/bin/qimgv";
        name = "qimgv";
        inherit icon;
        type = "Application";
        mimeType = mimeTypes;
      };
    };
  };
}
