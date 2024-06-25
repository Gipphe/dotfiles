{ lib, ... }:
{
  options.gipphe.networking.networkmanager.enable = lib.mkEnableOption "networkmanager";
}
