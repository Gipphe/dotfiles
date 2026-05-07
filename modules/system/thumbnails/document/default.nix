{ util, pkgs, ... }:
util.mkToggledModule [ "system" "thumbnails" ] {
  name = "document";
  system-nixos = {
    environment.systemPackages = builtins.attrValues {
      inherit (pkgs)
        poppler # PDF
        f3d # 3D files
        ;
    };
  };
}
