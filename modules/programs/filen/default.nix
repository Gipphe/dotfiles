{ pkgs, util, ... }:
let
  pkg = pkgs.symlinkJoin {
    inherit (pkgs.filen-desktop) name pname version;
    paths = [
      pkgs.filen-desktop
      (pkgs.linkFarm "filen-icon" {
        "share/pixmaps/filen-desktop.png" =
          "${pkgs.filen-desktop}/share/icons/hicolor/128x128/apps/filen-desktop.png";
      })
    ];
  };
in
util.mkProgram {
  name = "filen-desktop";
  hm = {
    home.packages = [ pkg ];
    wayland.windowManager.hyprland.settings.exec-once = [ "filen-desktop" ];
  };
}
