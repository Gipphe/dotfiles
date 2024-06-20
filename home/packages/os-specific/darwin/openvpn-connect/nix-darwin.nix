{
  lib,
  config,
  hmConfig,
  ...
}:
{
  config = lib.mkIf (config.homebrew.enable && hmConfig.gipphe.programs.openvpn-connect.enable) {
    homebrew.casks = [ "openvpn-connect" ];
  };
}
