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
  options.gipphe.user.username = lib.mkOption {
    description = "Username";
    type = lib.types.str;
    default = builtins.throw "gipphe.user.username is required";
  };
  options.gipphe.user.homeDirectory = lib.mkOption {
    description = "home directory";
    type = lib.types.str;
    default = builtins.throw "gipphe.user.homeDirectory is required";
  };
}
