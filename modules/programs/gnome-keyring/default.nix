{ util, ... }:
util.mkProgram {
  name = "gnome-keyring";
  system-nixos = {
    services.gnome.gnome-keyring.enable = true;
    security.pam.services.login.enableGnomeKeyring = true;
    programs.seahorse.enable = true;
  };
}
