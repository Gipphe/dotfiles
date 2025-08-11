{
  self,
  util,
  pkgs,
  ...
}:
let
  inherit (self.packages.${pkgs.system}) jdenticon-cli;
  icon = pkgs.runCommand "qimgv-icon" { } ''
    ${jdenticon-cli}/bin/jdenticon 'qimgv' -s 64 -o $out
  '';
in
util.mkProgram {
  name = "qimgv";
  hm = {
    home.packages = [ pkgs.qimgv ];
    xdg.desktopEntries.qimgv = {
      exec = "${pkgs.qimgv}/bin/qimgv";
      name = "qimgv";
      icon = icon.outPath;
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
