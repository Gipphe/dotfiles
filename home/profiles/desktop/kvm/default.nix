{ lib, config, ... }:
let
  inherit (config.gipphe.profiles) desktop;
in
{
  options.gipphe.profiles.desktop.kvm.enable = lib.mkEnableOption "desktop.kvm profile";
  config = lib.mkIf (desktop.enable && desktop.kvm.enable) { gipphe.programs.barrier.enable = true; };
}
