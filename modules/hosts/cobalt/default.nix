{ den, inputs, ... }:
{
  den.hosts.x86_64-linux.cobalt = {
    includes = [ den.batteries.define-user ];
    users.gipphe = { };
  };
  den.aspects.cobalt = {
    includes = [
      den.aspects.profiles.nixos.audio
      den.aspects.profiles.nixos.bluetooth
      den.aspects.profiles.nixos.boot
      den.aspects.profiles.nixos.camera
      den.aspects.profiles.nixos.networking
      den.aspects.profiles.nixos.printing
      den.aspects.profiles.nixos.power
      den.aspects.profiles.nixos.system
      den.aspects.profiles.nixos.thumbnails
      den.aspects.profiles.nixos.time
      den.aspects.profiles.nixos.zramswap

      # den.aspects.profiles.ai
      den.aspects.profiles.applications
      den.aspects.profiles.audio
      den.aspects.profiles.calendar
      den.aspects.profiles.cli
      den.aspects.profiles.core
      den.aspects.profiles.desktop.hyprland
      den.aspects.profiles.email
      den.aspects.profiles.gaming
      den.aspects.profiles.gc
      den.aspects.profiles.keyring
      den.aspects.profiles.laptop
      den.aspects.profiles.rice
      den.aspects.profiles.secrets
      den.aspects.profiles.sync
      den.aspects.profiles.systemd

      den.aspects.system.cpu
      den.aspects.hardware.disk
    ];

    homeManager = { config, ... }: {
      services.syncthing.guiCredentials.passwordFile =
        config.sensitive.secrets.secrets."cobalt/syncthing-password.txt";
    };

    nixos = { user }: {
      imports = [
        ./_hardware-configuration.nix
      ]
      ++ builtins.attrValues {
        inherit (inputs.nixos-hardware.nixosModules)
          common-cpu-intel
          common-gpu-amd
          common-pc-laptop
          common-pc-laptop-ssd
          ;
      };
      config = {
        users.users.${user.userName}.uid = 1000;
        users.groups.${user.userName}.gid = 990;
      };
    };
  };
}
