{ lib, flags, ... }:
{
  imports = [
    ./Jarle
    ./VNB-MB-Pro
    ./nixos-vm
    ./trond-arne
  ];
  options.gipphe = {
    username = lib.mkOption {
      description = "Username";
      type = lib.types.str;
      default = builtins.throw "gipphe.username is required";
    };
    homeDirectory = lib.mkOption {
      description = "home directory";
      type = lib.types.str;
      default = builtins.throw "gipphe.homeDirectory is required";
    };
    hostName = lib.mkOption {
      description = "HostName";
      type = lib.types.str;
      default = builtins.throw "gipphe.hostName is required";
    };
    flags = lib.mkOption {
      description = "For debugging";
      type = lib.types.anything;
      default = flags;
    };
  };
}
