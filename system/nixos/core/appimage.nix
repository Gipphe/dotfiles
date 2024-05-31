{
  lib,
  pkgs,
  flags,
  ...
}:
lib.optionalAttrs flags.gui {
  environment.systemPackages = with pkgs; [ appimage-run ];
  boot.binfmt.registrations =
    lib.genAttrs
      [
        "appimage"
        "AppImage"
      ]
      (ext: {
        recognitionType = "extension";
        magicOrExtension = ext;
        interpreter = "/run/current-system/sw/bin/appimage-run";
      });
}
