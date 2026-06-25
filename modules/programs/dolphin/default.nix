{
  inputs,
  util,
  pkgs,
  ...
}:
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
  nixos.nixpkgs.overlays = [ inputs.dolphin-overlay.overlays.default ];
}
