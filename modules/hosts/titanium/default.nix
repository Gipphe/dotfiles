{ den, inputs, ... }:
let
  monitors.left = "ASUSTek COMPUTER INC VG248 L9LMQS203421";
  monitors.right = "ASUSTek COMPUTER INC VG248 L9LMQS203414";

  minecraft.servers.dataDir = "/srv/minecraft";
in
{
  den.hosts.x86_64-linux.titanium = {
    includes = [
      den.batteries.define-user
    ];
    users.gipphe = { };
    settings.gaming = {
      inherit minecraft;
      gamescope.args = [
        "--prefer-output ${monitors.left}"
        "--output-width 1920"
        "--output-height 1080"
        "--nested-width 1920"
        "--nested-height 1080"
        "--adaptive-sync"
      ];
    };
  };

  den.aspects.gipphe.includes = [ den.batteries.primary-user ];

  den.aspects.titanium = {
    includes = [
      den.aspects.profiles.nixos.audio
      # den.aspects.profiles.nixos.biometrics
      den.aspects.profiles.nixos.bluetooth
      den.aspects.profiles.nixos.boot
      den.aspects.profiles.nixos.camera
      den.aspects.profiles.nixos.networking
      den.aspects.profiles.nixos.printing
      den.aspects.profiles.nixos.system
      den.aspects.profiles.nixos.thumbnails
      den.aspects.profiles.nixos.time
      den.aspects.profiles.nixos.zramswap

      den.aspects.profiles.ai
      den.aspects.profiles.applications
      den.aspects.profiles.audio
      den.aspects.profiles.calendar
      den.aspects.profiles.cli
      den.aspects.profiles.core
      den.aspects.profiles.desktop.hyprland
      den.aspects.profiles.email
      den.aspects.profiles.game-dev
      den.aspects.profiles.gaming
      den.aspects.profiles.gaming.psx
      den.aspects.profiles.gaming.stream.host
      den.aspects.profiles.gc
      den.aspects.profiles.keyring
      # TODO: Enable once fix is in nixos-unstable.
      # https://nixpk.gs/pr-tracker.html?pr=585583
      # den.aspects.profiles.rdp
      den.aspects.profiles.rice
      den.aspects.profiles.secrets
      den.aspects.profiles.sync
      den.aspects.profiles.systemd
      den.aspects.profiles.torrent
      den.aspects.profiles.tweag

      den.aspects.programs.comfyui
      den.aspects.programs.pipewire.higher-quantum
      den.aspects.programs.zen-browser.private
      den.aspects.programs.zen-browser.video

      den.aspects.hardware.cpu.intel.comet-lake
      den.aspects.hardware.gpu.nvidia.rtx3070
      den.aspects.hardware.disk
      den.aspects.hardware.motherboard.gigabyte.z490
      den.aspects.hardware.peripheral.logitech.a50gen5
      den.aspects.hardware.peripheral.logitech.g502x
      den.aspects.hardware.peripheral.logitech.g915
      den.aspects.hardware.peripheral.xbox.one.controller

      den.aspects.gaming.minecraft.servers
      den.aspects.gaming.minecraft.worlds.poketards

      (den.aspects.titanium.restic [ minecraft.servers.dataDir ])
      den.aspects.titanium.ssh

      (den.batteries.unfree [ "megasync" ])
    ];

    homeManager = { user }: { pkgs, config, ... }: {
      home.packages = [
        pkgs.megasync
      ];
      wayland.windowManager.hyprland.settings = {
        monitor = [
          {
            output = "desc:${monitors.left}";
            mode = "preferred";
            position = "0x0";
            scale = 1.0;
          }
          {
            output = "desc:${monitors.right}";
            mode = "preferred";
            position = "auto-right";
            scale = 1.0;
          }
        ];
        workspace_rule = [
          {
            workspace = "1";
            default = true;
            monitor = "desc:${monitors.left}";
          }
          {
            workspace = "9";
            default = true;
            monitor = "desc:${monitors.right}";
          }
        ];
      };
      services.syncthing = {
        settings.folders."${user.homeDirectory}/Documents/Notes".path = "/mnt/oldone/Filen/Area/Notes";
        guiCredentials.passwordFile = config.sensitive.secrets.secrets."titanium/syncthing-password.txt";
      };
    };

    nixos = { pkgs, lib, ... }: {
      imports = [
        ./_hardware-configuration.nix
        inputs.disko.nixosModules.disko
        ./_disks
        "${inputs.nixos-hardware}/common/gpu/nvidia/ampere"
      ]
      ++ builtins.attrValues {
        inherit (inputs.nixos-hardware.nixosModules)
          common-pc
          common-pc-ssd
          ;
      };

      programs.gamemode.settings = {
        gpu.gpu_device = 1;
      };

      services.sunshine = {
        settings.output_name = "DP-2";
        applications.apps =
          let
            detached = pkgs.writeShellApplication {
              name = "sunshine-steam-detached";
              text = ''
                setsid steam steam://open/bigpicture
                sleep 3s
                hyprctl dispatch 'hl.dsp.workspace.toggle_special("steam")'
                hyprctl dispatch 'hl.dsp.window.move { initialclass = "steam", workspace = "special:steam" }'
              '';
            };
            undo = pkgs.writeShellApplication {
              name = "sunshine-steam-undo";
              text = ''
                setsid steam steam://close/bigpicture
                hyprctl dispatch 'hl.dsp.workspace.toggle_special("steam")'
              '';
            };
          in
          [
            {
              name = "Steam Big Picture (dedicated workspace)";
              detached = [ (lib.getExe detached) ];
              prep-cmd = [
                {
                  do = "";
                  undo = lib.getExe undo;
                }
              ];
              image-path = "steam.png";
            }
          ];
      };

      hardware.nvidia.prime.nvidiaBusId = "PCI:1@0:0:0";

      system.stateVersion = "26.05";

      boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
    };
  };
}
