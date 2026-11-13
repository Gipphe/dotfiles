{
  den.aspects.programs.gnome-keyring.nixos = {
    services.gnome.gnome-keyring.enable = true;

    security.pam.services = {
      login.enableGnomeKeyring = true;
      sddm.enableGnomeKeyring = true;
      ly.enableGnomeKeyring = true;
    };
  };
}
