{ util, ... }:
util.mkProfile "home-vpn" {
  gipphe.networking.wireguard.enable = true;
}
