{
  pkgs,
  util,
  lib,
  config,
  ...
}:
util.mkToggledModule [ "boot" ] {
  name = "limine";
  options.gipphe.boot.limine.secureBoot.enable = lib.mkEnableOption "limine secure boot";
  nixos.boot.loader.limine = {
    enable = true;
    efiSupport = true;
    extraEntries = ''
      /memtest86
        protocol: chainload
        path: boot():///efi/memtest86/memtest86.efi
    '';
    resolution = "1920x1080x32";
    secureBoot.enable = config.gipphe.boot.limine.secureBoot.enable;
    maxGenerations = 30;
    style.interface.resolution = "1920x1080";
    additionalFiles = {
      "efi/memtest86/memtest86.efi" = "${pkgs.memtest86-efi}/BOOTX64.efi";
    };
  };
}
