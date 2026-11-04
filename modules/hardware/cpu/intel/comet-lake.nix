{
  den.aspects.hardware.cpu.intel.comet-lake = {
    nixos = {
      hardware = {
        cpu.intel.updateMicrocode = true;
        enableRedistributableFirmware = true;
      };
    };
  };
}
