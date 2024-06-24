{ lib, ... }:
{
  options.gipphe.programs.openvpn-connect.enable = lib.mkEnableOption "openvpn-connect";
}
