{
  lib,
  util,
  pkgs,
  ...
}:
util.mkProgram {
  name = "appimage";
  system-nixos = {
    environment.systemPackages = [ pkgs.appimage-run ];
    boot.binfmt.registrations =
      lib.genAttrs
        [
          "appimage"
          "AppImage"
        ]
        (ext: {
          recognitionType = "extension";
          magicOrExtension = ext;
          interpreter = lib.getExe pkgs.appimage-run;
        });
  };
}
