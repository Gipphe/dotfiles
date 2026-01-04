{ util, ... }:
util.mkProgram {
  name = "qemu";
  system-nixos = {
    # environment.systemPackages = [
    #   pkgs.virt-viewer
    # ];
    programs.virt-manager.enable = true;
    virtualisation = {
      libvirtd = {
        enable = true;
        onBoot = "ignore";
      };
      spiceUSBRedirection.enable = true;
    };
  };
}
