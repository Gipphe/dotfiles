{ lib, ... }:
{
  # Handled by nix-darwin in ./nix-darwin.nix
  options.gipphe.programs.openvpn-connect.enable = lib.mkEnableOption "openvpn-connect";
}
