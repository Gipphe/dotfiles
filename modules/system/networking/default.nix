{ config, util, ... }:
util.mkModule {
  system-all.networking.hostName = config.gipphe.hostName;
}
