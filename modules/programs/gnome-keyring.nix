{
  den.aspects.programs.gnome-keyring.nixos =
    { pkgs, ... }:
    {
      services.gnome.gnome-keyring.enable = true;
      security.pam.services = {
        login.enableGnomeKeyring = true;
        sddm.enableGnomeKeyring = true;
      };
      environment.systemPackages = [ pkgs.gcr_4 ];
    };
}
