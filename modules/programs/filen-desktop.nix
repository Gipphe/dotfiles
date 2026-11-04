{
  den.aspects.programs.filen-desktop.homeManager =
    { pkgs, ... }:
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
    {
      home.packages = [ pkg ];
      gipphe.core.wm.triggers.on-startup.filen-desktop.command = "sleep 60s && ${pkg}/bin/filen-desktop";
    };
}
