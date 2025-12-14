{ util, ... }:
util.mkSystem {
  name = "fprint";
  system-nixos = {
    services.fprintd.enable = true;
    security.pam.services = {
      hyprlock.fprintAuth = true;
      login.fprintAuth = true;
      sddm-autologin.fprintAuth = true;
      sddm-greeter.fprintAuth = true;
      sddm.fprintAuth = true;
      sudo.fprintAuth = true;
    };
  };
}
