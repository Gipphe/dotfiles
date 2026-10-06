{
  inputs,
  pkgs,
  util,
  ...
}:
let
  # TODO: Remove once this PR is in nixos-unstable:
  # https://github.com/NixOS/nixpkgs/pull/569777
  filenPkg =
    inputs.nixpkgs-filen-desktop.legacyPackages.${pkgs.stdenv.hostPlatform.system}.filen-desktop;
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
