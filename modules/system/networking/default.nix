{ config, util, ... }:
let
  networking = {
    hostName = config.gipphe.hostName;
  };
in
util.mkModule {
  system-nixos.networking = networking;
  system-darwin.networking = networking;
}
