{ util, pkgs, ... }:
util.mkProgram {
  name = "qemu";
  system-nixos = {
    # environment.systemPackages = with pkgs; [
    #   virt-viewer
    # ];
    programs.virt-manager.enable = true;
    virtualisation = {
      libvirtd = {
        enable = true;
        onBoot = "ignore";
        qemu.ovmf.enable = true;
      };
      spiceUSBRedirection.enable = true;
    };
  };
}
