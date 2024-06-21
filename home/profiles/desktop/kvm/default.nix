{ lib, config, ... }:
{
  options.gipphe.profiles.desktop.kvm.enable = lib.mkEnableOption "desktop.kvm profile";
  config = lib.mkIf config.gipphe.profiles.desktop.kvm.enable {
    gipphe.programs.barrier.enable = true;
  };
}
