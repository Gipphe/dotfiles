{ util, ... }:
util.mkToggledModule [ "system" ] {
  name = "zramswap";
  # compress half of the ram to use as swap
  system-nixos.zramSwap = {
    enable = true;
    algorithm = "zstd";
  };
}
