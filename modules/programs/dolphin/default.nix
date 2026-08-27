{ util, pkgs, ... }:
util.mkProgram {
  name = "dolphin";
  homeManager.home.packages = builtins.attrValues {
    # Depends on the dolphin-overlay enabled in
    # `../../../environments/nixpkgs.nix`.
    inherit (pkgs.kdePackages)
      dolphin
      ark # Archiving support in Dolphin
      dolphin-plugins # Git and mounting integrations
      kio-admin # Manage files as admin
      ;
  };
}
