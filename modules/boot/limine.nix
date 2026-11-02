{ den, ... }: {
  den.aspects.boot.limine = {
    includes = [ (den.batteries.unfree [ "memtest86-efi" ]) ];
    nixos = { pkgs, ... }: {
      boot.loader.limine = {
        enable = true;
        efiSupport = true;
        extraEntries = ''
          /memtest86
            protocol: chainload
            path: boot():///efi/memtest86/memtest86.efi
        '';
        resolution = "1920x1080x32";
        maxGenerations = 30;
        style.interface.resolution = "1920x1080";
        additionalFiles = {
          "efi/memtest86/memtest86.efi" = "${pkgs.memtest86-efi}/BOOTX64.efi";
        };
      };
    };
  };
}
