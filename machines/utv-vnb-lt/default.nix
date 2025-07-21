{
  pkgs,
  hostname,
  util,
  inputs,
  config,
  lib,
  ...
}:
let
  name = "utv-vnb-lt";
in
util.mkToggledModule [ "machines" ] {
  inherit name;

  shared.gipphe = {
    username = "gipphe";
    homeDirectory = "/home/gipphe";
    hostName = name;
    profiles = {
      nixos = {
        audio.enable = true;
        bluetooth.enable = true;
        boot-efi.enable = true;
        devices.enable = true;
        power.enable = true;
        system.enable = true;
      };
      ai.enable = true;
      audio.enable = true;
      cli.enable = true;
      core.enable = true;
      desktop-hyprland.enable = true;
      desktop.enable = true;
      fonts.enable = true;
      gaming.enable = true;
      gc.enable = true;
      logitech.enable = true;
      networkmanager.enable = true;
      lovdata.enable = true;
      rice.enable = true;
      secrets.enable = true;
      sync.enable = true;
      systemd.enable = true;
      windows-setup.enable = true;
    };
  };

  hm = {
    home.packages = [
      (util.GPUOffloadApp pkgs.steam "steam")
    ];
    wayland.windowManager.hyprland.settings.monitor = [
      "DP-7, preferred, 0x0, 1"
      "DP-8, preferred, auto-right, 1"
      "DP-9, preferred, auto-left, 1"
      "eDP-1, preferred, auto-down, 1"
      ", preferred, auto, 1"
    ];
  };

  system-nixos = {
    imports = lib.optionals (hostname == name) (
      with inputs.nixos-hardware.nixosModules;
      [
        (import "${inputs.nixos-hardware}/common/cpu/intel/raptor-lake")
        common-pc-laptop
        common-pc-ssd
        common-gpu-nvidia
      ]
    );

    services.xserver.videoDrivers = [
      "modesetting"
      "nvidia"
    ];
    hardware = {
      enableRedistributableFirmware = true;
      graphics = {
        enable = true;
        enable32Bit = true;
      };
      nvidia = {
        powerManagement = {
          enable = false;
          finegrained = true;
        };
        package = config.boot.kernelPackages.nvidiaPackages.stable;
        nvidiaSettings = true;
        modesetting.enable = true;
        open = true;
        prime = {
          intelBusId = "PCI:0:2:0";
          nvidiaBusId = "PCI:1:0:0";
          offload = {
            enable = true;
            enableOffloadCmd = true;
          };
        };
      };
    };

    # Override Intel GPU driver from common-cpu-intel-raptor-lake module.
    environment.variables.VDPAU_DRIVER = lib.mkIf config.hardware.graphics.enable (
      lib.mkOverride 990 "nvidia"
    );

    services.thermald.enable = true;
    # powersave or performance.
    powerManagement.cpuFreqGovernor = lib.mkDefault "performance";

    boot.initrd.luks.devices."luks-03a05c7c-fec2-435a-a17c-40693494c8ea".device =
      "/dev/disk/by-uuid/03a05c7c-fec2-435a-a17c-40693494c8ea";

    system.stateVersion = "25.05";
  };
}
