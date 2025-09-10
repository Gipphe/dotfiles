{
  util,
  pkgs,
  config,
  lib,
  ...
}:
util.mkProgram {
  name = "gnome-keyring";
  system-nixos = {
    services.gnome.gnome-keyring.enable = true;
    security.pam.services = {
      login.enableGnomeKeyring = true;
    }
    // lib.optionalAttrs config.gipphe.programs.sddm.enable {
      sddm.enableGnomeKeyring = true;
    };
    environment.systemPackages = [ pkgs.gcr ];
  };
}
