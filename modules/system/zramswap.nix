{
  # compress half of the ram to use as swap
  den.aspects.system.zramswap.nixos.zramSwap = {
    enable = true;
    algorithm = "zstd";
  };
}
