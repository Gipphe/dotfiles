{ lib, config, ... }:
{
  config = lib.mkIf config.gipphe.system.nix-ld.enable {
    programs = {
      # Compatibility layer for dynamically linked binaries that expect FHS
      nix-ld.enable = true;
    };
  };
}
