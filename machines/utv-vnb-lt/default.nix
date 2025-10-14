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

  left-monitor = "Dell Inc. DELL U2724D G15V4Z3";
  right-monitor = "Dell Inc. DELL U2724D G27V4Z3";
  center-monitor = "Dell Inc. DELL U2724D G11T4Z3";
  laptop-monitor = "AU Optronics 0x31A6 Unknown";
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
        thumbnails.enable = true;
        time.enable = true;
      };
      ai.enable = true;
      application.enable = true;
      audio.enable = true;
      cli.enable = true;
      core.enable = true;
      desktop.hyprland.enable = true;
      fonts.enable = true;
      gaming.android.enable = false;
      gaming.enable = true;
      gc.enable = true;
      keyring.enable = true;
      laptop.enable = true;
      logitech.enable = true;
      lovdata.enable = true;
      multi-monitor.enable = true;
      networkmanager.enable = true;
      rice.enable = true;
      secrets.enable = true;
      sync.enable = true;
      systemd.enable = true;
      terminal-capture.enable = true;
      vm-host.enable = true;
    };
    hardware = {
      logi-mx-keys.enable = true;
    };
  };

  hm = {
    home.packages = [
      (util.GPUOffloadApp pkgs.steam "steam")
    ];
    gipphe.core.wm.binds =
      let
        brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
      in
      lib.mkIf false [
        {
          key = "code:72";
          action.spawn = "${brightnessctl} set 10%-";
        }
        {
          key = "code:73";
          action.spawn = "${brightnessctl} set 10%+";
        }
      ];
    wayland.windowManager.hyprland.settings = {
      monitor = [
        "desc:${center-monitor}, preferred, 0x0, 1"
        "desc:${right-monitor}, preferred, auto-right, 1"
        "desc:${left-monitor}, preferred, auto-left, 1"
        ", preferred, auto-down, 1"
      ];
    };

    gipphe.programs.wf-recorder.nicknames = {
      "${center-monitor}" = "center";
      "${right-monitor}" = "right";
      "${left-monitor}" = "left";
    };

    services.kanshi.settings = [
      {
        output.criteria = left-monitor;
        output.alias = "left";
      }
      {
        output.criteria = right-monitor;
        output.alias = "right";
      }
      {
        output.criteria = center-monitor;
        output.alias = "center";
      }
      {
        output.criteria = laptop-monitor;
        output.alias = "laptop";
      }
      {
        profile.name = "undocked";
        profile.outputs = [
          {
            criteria = "$laptop";
            status = "enable";
          }
        ];
      }
      {
        profile.name = "docked";
        profile.outputs = [
          {
            criteria = "$laptop";
            status = "disable";
          }
          { criteria = "$left"; }
          { criteria = "$center"; }
          { criteria = "$right"; }
        ];
      }
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

    boot = {
      kernelModules = [
        "drm_kms_helper"
      ];
      extraModprobeConfig = ''
        options drm_kms_helper poll=N
      '';
      initrd = {
        luks.devices."luks-03a05c7c-fec2-435a-a17c-40693494c8ea".device =
          "/dev/disk/by-uuid/03a05c7c-fec2-435a-a17c-40693494c8ea";
      };
    };

    users = {
      groups.${config.gipphe.username}.gid = 993;
      users.${config.gipphe.username}.uid = 1000;
    };

    # Override Intel GPU driver from common-cpu-intel-raptor-lake module.
    environment.variables.VDPAU_DRIVER = lib.mkIf config.hardware.graphics.enable (
      lib.mkOverride 990 "nvidia"
    );

    services = {
      thermald.enable = true;
      logind.settings.Login = {
        HandleLidSwitchExternalPower = "suspend";
        HandleLidSwitchDocked = "ignore";
      };
    };
    # powersave or performance.
    powerManagement.cpuFreqGovernor = lib.mkDefault "performance";

    system.stateVersion = "25.05";
  };
}
