{
  pkgs,
  lib,
  config,
  ...
}:
let
  dnscrypt = config.services.dnscrypt-proxy2.enable;
  inherit (lib) mkIf;
in
{ }
