{ lib, config, ... }:
{
  config = lib.mkIf config.gipphe.system.zramswap.enable {
    # compress half of the ram to use as swap
    zramSwap = {
      enable = true;
      algorithm = "zstd";
    };
  };
}
