{ config, pkgs, lib, nixpkgs, ... }:

{
  home.packages = with pkgs; [ openvpn ];
}
