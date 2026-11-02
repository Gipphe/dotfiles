{ den, ... }: {
  den.aspects.hardware.peripheral.logitech.a50gen5 = {
    includes = [ den.aspects.programs.headset-battery-indicator ];
    nixos =
      { pkgs, ... }:
      {
        programs.solaar = {
          enable = true;
          userService.enable = true;
        };
        environment.systemPackages = [ pkgs.headsetcontrol ];
        services = {
          hardware.openrgb.enable = true;
          udev = {
            enable = true;
            packages = [ pkgs.headsetcontrol ];
          };
        };
      };
  };
}
