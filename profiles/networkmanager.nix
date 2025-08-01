{ util, ... }:
util.mkProfile {
  name = "networkmanager";
  shared.gipphe.networking.networkmanager.enable = true;
}
