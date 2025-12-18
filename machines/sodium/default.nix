{
  hostname,
  util,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  host = import ./host.nix;
in
util.mkToggledModule [ "machines" ] {
  inherit (host) name;

  shared.gipphe = {
    username = "gipphe";
    homeDirectory = "/home/gipphe";
    hostName = host.name;
    profiles = {
      nixos = {
        audio.enable = true;
        bluetooth.enable = true;
        boot-efi.enable = true;
        camera.enable = true;
        devices.enable = true;
        networking.enable = true;
        power.enable = true;
        system.enable = true;
        thumbnails.enable = true;
        time.enable = true;
      };
      cli.enable = true;
      core.enable = true;
      desktop.plasma.enable = true;
      fonts.enable = true;
      gc.enable = true;
      keyring.enable = true;
      secrets.enable = true;
    };
    # system.cpu.enable = true;
  };

  hm = {
    wayland.windowManager.hyprland.settings = {
      monitor = [
        ", preferred, auto-down, auto"
      ];
    };
  };

  system-nixos = {
    imports = lib.optionals (hostname == host.name) [
      inputs.nixos-hardware.nixosModules.raspberry-pi-4
    ];

    boot.kernelParams = [ "kunit.enable=0" ];
    hardware.deviceTree.filter = "bcm2711-rpi-4*.dtb";
    boot = {
      initrd.systemd.tpm2.enable = false;
      initrd.availableKernelModules = [
        "usbhid"
        "usb_storage"
        "vc4"
        "pcie_brcmstb" # required for the pcie bus to work
        "reset-raspberrypi" # required for vl805 firmware to load
      ];
    };

    hardware.enableRedistributableFirmware = true;

    # networking.useDHCP = true;
    networking.interfaces.eth0.useDHCP = true;
    networking.interfaces.wlan0.useDHCP = true;

    powerManagement.cpuFreqGovernor = "ondemand";

    environment.systemPackages = with pkgs; [
      raspberrypi-eeprom
    ];

    environment = {
      # This allows alacritty to run
      extraInit = ''
        export LIBGL_ALWAYS_SOFTWARE=1
      '';
    };

    system.stateVersion = "26.05";
  };
}
