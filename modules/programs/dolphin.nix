{ inputs, ... }:
{
  den.aspects.programs.dolphin = {
    homeManager = { pkgs, ... }: {
      home.packages = builtins.attrValues {
        inherit (pkgs.kdePackages)
          dolphin
          ark # Archiving support in Dolphin
          dolphin-plugins # Git and mounting integrations
          kio-admin # Manage files as admin
          ;
      };
    };
    nixos.nixpkgs.overlays = [
      inputs.dolphin-overlay.overlays.default
    ];
  };
}
