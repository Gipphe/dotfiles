{ util, pkgs, ... }:
util.mkProgram {
  name = "dolphin";
  homeManager.home.packages = builtins.attrValues {
    inherit (pkgs.kdePackages)
      dolphin
      ark # Archiving support in Dolphin
      dolphin-plugins # Git and mounting integrations
      kio-admin # Manage files as admin
      ;
  };
}
