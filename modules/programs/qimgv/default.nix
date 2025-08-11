{ util, pkgs, ... }:
util.mkProgram {
  name = "qimgv";
  hm = {
    home.packages = [ pkgs.qimgv ];
    xdg.desktopEntries.qimgv = {
      exec = "${pkgs.qimgv}/bin/qimgv";
      name = "qimgv";
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
