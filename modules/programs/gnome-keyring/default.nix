{ util, ... }:
util.mkProgram {
  name = "gnome-keyring";
  system-nixos.services.gnome.gnome-keyring = {
    enable = true;
  };
}
