{ lib, config, ... }:
{
  config = lib.mkIf (config.homebrew.enable && config.gipphe.programs.openvpn-connect.enable) {
    homebrew.casks = [ "openvpn-connect" ];
  };
}
