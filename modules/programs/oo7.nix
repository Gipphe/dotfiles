{
  den.aspects.programs.oo7.nixos = { pkgs, ... }: {
    services.oo7.enable = true;

    security.pam.services = {
      ly.oo7.enable = true;
      sddm.oo7.enable = true;
      login.oo7.enable = true;
    };

    services.dbus.packages = [ pkgs.gcr_4 ];
  };
}
