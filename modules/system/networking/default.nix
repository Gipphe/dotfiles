{ config, util, ... }:
util.mkModule {
  system-nixos.networking = {
    inherit (config.gipphe) hostName;
  };
}
