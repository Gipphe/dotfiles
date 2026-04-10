{
  disko.devices.disk.oldone = {
    type = "disk";
    device = "/dev/disk/by-id/ata-ST2000DX002-2DV164_Z4ZA11VT";
    content.type = "gpt";
    content.partitions.main = {
      name = "oldone";
      size = "100%";
      content = {
        type = "btrfs";
        extraArgs = [ "-f" ];
        subvolumes."/main" = {
          mountpoint = "/mnt/oldone";
          mountOptions = [
            "compress=zstd"
            "noatime"
          ];
        };
      };
    };
  };
}
