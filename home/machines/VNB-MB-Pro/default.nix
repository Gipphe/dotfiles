{
  lib,
  config,
  flags,
  ...
}:
{
  imports = lib.optional flags.isSystem ./system-all.nix;
  options.gipphe.machines.VNB-MB-Pro.enable = lib.mkEnableOption "VNB-MB-Pro machine config";
  config = lib.mkIf config.gipphe.machines.VNB-MB-Pro.enable {
    gipphe = {
      username = "victor";
      homeDirectory = "/Users/victor";
      profiles = {
        ai.enable = true;
        cli.enable = true;
        containers.enable = true;
        core.enable = true;
        darwin.enable = true;
        desktop.enable = true;
        k8s.enable = true;
        kvm.enable = true;
        logitech.enable = true;
        music.enable = true;
        rice.enable = true;
        secrets.enable = true;
        work.enable = true;
      };
    };
  };
}
