{
  den.aspects.hardware.motherboard.gigabyte.z490 = {
    nixos =
      { pkgs, config, ... }:
      {
        # Needed for lm_sensors to read the motherboard's thermal sensors and fan
        # speeds.
        boot.extraModulePackages = [ config.boot.kernelPackages.it87 ];
        boot.kernelModules = [ "it87" ];
        environment.systemPackages = [ pkgs.lm_sensors ];
      };
  };
}
