{ config, util, ... }:
let
  networking = {
    inherit (config.gipphe) hostName;
  };
in
util.mkModule {
  system-nixos.networking = networking;
  system-darwin.networking = networking;
}
