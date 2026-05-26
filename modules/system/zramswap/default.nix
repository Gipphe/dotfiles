{ util, ... }:
util.mkToggledModule [ "system" ] {
  name = "zramswap";
  # compress half of the ram to use as swap
  nixos.zramSwap = {
    enable = true;
    algorithm = "zstd";
  };
}
