{ den, ... }: {
  den.aspects.hardware.peripheral.logitech.g502x = {
    includes = [ den.aspects.programs.openmouse-bridge ];
    homeManager = { pkgs, ... }: {
      home.packages = [ pkgs.piper ];
    };
    nixos = {
      programs.solaar = {
        enable = true;
        userService.enable = true;
      };
      services = {
        ratbagd.enable = true;
        libinput.enable = true;
        hardware.openrgb.enable = true;
      };
    };
  };
}
