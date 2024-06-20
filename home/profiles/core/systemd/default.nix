{ lib, config, ... }:
let
  inherit (config.gipphe.profiles) core;
in
{
  options.gipphe.profiles.core.systemd.enable = lib.mkEnableOption "core.systemd profile";
  config = lib.mkIf (core.enable && core.systemd.enable) {
    gipphe.programs.run-as-service.enable = true;
  };
}
