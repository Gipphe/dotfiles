{ lib, config, ... }:
{
  options.gipphe.profiles.kvm.enable = lib.mkEnableOption "kvm profile";
  config = lib.mkIf config.gipphe.profiles.kvm.enable { gipphe.programs.barrier.enable = true; };
}
