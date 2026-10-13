{ pkgs, util, ... }:
let
  filenPkg = pkgs.filen-desktop;
  pkg = pkgs.symlinkJoin {
    inherit (filenPkg) name pname version;
    paths = [
      filenPkg
      (pkgs.linkFarm "filen-icon" {
        "share/pixmaps/filen-desktop.png" =
          "${filenPkg}/share/icons/hicolor/128x128/apps/filen-desktop.png";
      })
    ];
  };
in
util.mkProgram {
  name = "filen-desktop";
  homeManager = {
    home.packages = [ pkg ];
    gipphe.core.wm.triggers.on-startup.filen.command = "sleep 60s && filen-desktop";
  };
}
