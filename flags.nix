{ lib, config, ... }:
let
  mkRequired =
    desc: mkOption: opts:
    mkOption opts // { default = throw "${desc} is a required flag"; };
in
{
  options.gipphe.flags = {
    system = mkRequired "system" lib.mkOption {
      description = "system";
      type = lib.types.str;
    };
    isNixos = lib.mkEnableOption "nixos" // {
      default = lib.hasSuffix "linux" config.gipphe.flags.system;
    };
    isNixDarwin = lib.mkEnableOption "nix-darwin" // {
      default = lib.hasSuffix "darwin" config.gipphe.flags.system;
    };
    isHm = lib.mkEnableOption "home-manager";
    isSystem = lib.mkEnableOption "system config" // {
      default = config.gipphe.flags.isNixos || config.gipphe.flags.isNixDarwin;
    };
  };
}
