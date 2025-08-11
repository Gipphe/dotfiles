{ lib, flags, ... }:
{
  imports = lib.pipe ./. [
    builtins.readDir
    (lib.filterAttrs (_: t: t == "directory"))
    builtins.attrNames
    (builtins.map (n: ./${n}))
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
    host = lib.mkOption {
      description = "Host configuration";
      type =
        with lib.types;
        attrsOf (submodule {
          options = {
            system = lib.mkOption {
              description = "pkgs.system doublet";
              example = "x86_64-linux";
              type = lib.types.str;
            };
            machine = lib.mkOption {
              description = "Type of nix machine.";
              example = "nixos";
              type =
                with lib.types;
                enum [
                  "nixos"
                  "nix-on-droid"
                  "nix-darwin"
                ];
            };
          };
        });
      default = { };
    };
  };
}
