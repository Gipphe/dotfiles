{ den, inputs, ... }:
{
  den.hosts.x86_64-linux.boron = {
    users.gipphe = { };
  };

  den.aspects.boron = {
    includes = [
      den.aspects.profiles.nixos.audio
      # den.aspects.profiles.nixos.biometrics
      den.aspects.profiles.nixos.bluetooth
      den.aspects.profiles.nixos.boot
      den.aspects.profiles.nixos.camera
      den.aspects.profiles.nixos.networking
      den.aspects.profiles.nixos.printing
      den.aspects.profiles.nixos.power
      den.aspects.profiles.nixos.system
      den.aspects.profiles.nixos.thumbnails
      den.aspects.profiles.nixos.time

      den.aspects.profiles.ai
      den.aspects.profiles.applications
      den.aspects.profiles.audio
      den.aspects.profiles.calendar
      den.aspects.profiles.cli
      den.aspects.profiles.core
      den.aspects.profiles.desktop.hyprland
      den.aspects.profiles.email
      den.aspects.profiles.gaming
      den.aspects.profiles.gaming.stream.host
      den.aspects.profiles.gc
      den.aspects.profiles.keyring
      den.aspects.profiles.laptop
      den.aspects.profiles.rice
      den.aspects.profiles.secrets
      den.aspects.profiles.sync
      den.aspects.profiles.systemd
      den.aspects.profiles.torrent

      den.aspects.programs.pipewire.higher-quantum
      den.aspects.system.cpu

      den.aspects.hardware.disk
    ];

    homeManager = { lib, config, ... }: {
      programs.noctalia.settings.idle.behavior = {
        lock = lib.mkForce {
          enabled = true;
          timeout = 300;
        };
        lock-and-suspend = lib.mkForce {
          enabled = true;
          timeout = 420;
        };
        screen-off = lib.mkForce {
          enabled = true;
          timeout = 330;
        };
      };
      wayland.windowManager.hyprland.settings.monitor = [
        {
          output = "desc:Samsung Display Corp. 0x4193";
          mode = "preferred";
          position = "0x0";
          scale = "auto";
        }
        {
          output = "";
          mode = "preferred";
          position = "auto-down";
          scale = "auto";
        }
      ];

      programs = {
        ssh.settings."sodium.lan" = {
          hostname = "sodium.lan";
          user = "gipphe";
          identityFile = config.sensitive.secrets.secrets."boron/sodium.ssh";
        };
      };

      services.syncthing.guiCredentials.passwordFile =
        config.sensitive.secrets.secrets."boron/syncthing-password.txt";
    };

    nixos = { lib, ... }: {
      imports = [
        inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-11th-gen
        ./_hardware-configuration.nix
      ];

      system.stateVersion = "25.05";
      users = {
        users.gipphe.uid = lib.mkForce null;
        groups.gipphe.gid = lib.mkForce null;
      };
    };
  };
}
