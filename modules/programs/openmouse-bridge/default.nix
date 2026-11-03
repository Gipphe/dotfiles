{
  self,
  pkgs,
  util,
  ...
}:
util.mkProgram {
  name = "openmouse-bridge";
  nixos = {
    environment.systemPackages = [ self.packages.${pkgs.stdenv.hostPlatform.system}.openmouse-bridge ];
    services.udev.extraRules = ''
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="046d", MODE="0660", GROUP="input", TAG+="uaccess"
    '';
  };
}
