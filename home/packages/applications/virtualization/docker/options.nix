{ lib, ... }:
{
  # Managed by NixOS and nix-darwin
  options.gipphe.virtualisation.docker.enable = lib.mkEnableOption "docker";
}
