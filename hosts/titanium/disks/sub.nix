{
  disko.devices.disk.sub = {
    type = "disk";
    device = "/dev/disk/by-id/nvme-KINGSTON_SA1000M8960G_50026B7682BAE0A9";
    content = {
      type = "gpt";
      partitions.main = {
        name = "sub";
        size = "100%";
        content = {
          type = "btrfs";
          extraArgs = [ "-f" ];
          subvolumes."/main" = {
            mountpoint = "/mnt/sub";
            mountOptions = [
              "compress=zstd"
              "noatime"
            ];
          };
        };
      };
    };
  };
}
