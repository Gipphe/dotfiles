{ util, ... }:
util.mkToggledModule [ "hardware" "cpu" "intel" ] {
  name = "comet-lake";
  system-nixos = {
    hardware = {
      cpu.intel.updateMicrocode = true;
      enableRedistributableFirmware = true;
    };
  };
}
