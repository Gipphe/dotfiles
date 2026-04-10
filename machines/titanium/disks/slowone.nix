{
  disko.devices.disk.slowone = {
    type = "disk";
    device = "/dev/disk/by-id/ata-ST2000DX001-1CM164_Z1E7FPDD";
    content.type = "gpt";
    content.partitions.main = {
      name = "slowone";
      size = "100%";
      content = {
        type = "btrfs";
        extraArgs = [ "-f" ];
        subvolumes."/main" = {
          mountpoint = "/mnt/slowone";
          mountOptions = [
            "compress=zstd"
            "noatime"
          ];
        };
      };
    };
  };
}
