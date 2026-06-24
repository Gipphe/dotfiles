{ lib, flags, ... }:
let
  inherit (builtins) readDir attrNames;
in
{
  imports = lib.pipe ./. [
    readDir
    (lib.filterAttrs (_: t: t == "directory"))
    attrNames
    (map (n: ./${n}))
  ];
  options.gipphe = {
    username = lib.mkOption {
      description = "Username";
      type = lib.types.str;
      default = throw "gipphe.username is required";
    };
    homeDirectory = lib.mkOption {
      description = "home directory";
      type = lib.types.str;
      default = throw "gipphe.homeDirectory is required";
    };
    hostName = lib.mkOption {
      description = "HostName";
      type = lib.types.str;
      default = throw "gipphe.hostName is required";
    };
    flags = lib.mkOption {
      description = "For debugging";
      type = lib.types.anything;
      default = flags;
    };
  };
}
