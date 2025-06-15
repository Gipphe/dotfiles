{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  imports = [ ];
  boot.initrd.availableKernelModules = [
    "ata_piix"
    "ohci_pci"
    "ehci_pci"
    "ahci"
    "sd_mod"
    "sr_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/354a0e89-0522-475a-ae1b-c3b7c1ef7340";
    fsType = "ext4";
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/F1CA-7FF4";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };
  swapDevices = [
    {
      device = "/dev/disk/by-uuid/1c415f93-f0fa-4d25-9fbe-045f5f648b5c";
    }
  ];
  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  virtualisation.virtualbox.guest.enable = true;
}
