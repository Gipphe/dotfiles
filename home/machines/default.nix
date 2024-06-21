{ lib, ... }:
{
  options.gipphe.machine = lib.mkOption {
    description = "Machine whose configuration to use";
    type = lib.types.enum [
      "Jarle"
      "VNB-MB-Pro"
      "nixos-vm"
      "trond-arne"
    ];
    example = "Jarle";
    default = throw "gipphe.machine is required";
  };
}
