{ util, ... }:
util.mkProfile {
  name = "home-vpn";
  shared.gipphe.networking.wireguard.enable = true;
}
