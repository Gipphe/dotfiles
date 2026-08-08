{
  pkgs,
  config,
  hostname,
  util,
  inputs,
  lib,
  ...
}:
let
  host = import ./host.nix;
  monitors.left = "ASUSTek COMPUTER INC VG248 L9LMQS203421";
  monitors.right = "ASUSTek COMPUTER INC VG248 L9LMQS203414";
in
util.mkToggledModule [ "hosts" ] {
  inherit (host) name;

  shared.gipphe = {
    username = "gipphe";
    homeDirectory = "/home/gipphe";
    hostName = host.name;
    profiles = {
      nixos = {
        audio.enable = true;
        biometrics.enable = false;
        bluetooth.enable = true;
        boot.enable = true;
        camera.enable = true;
        networking.enable = true;
        printing.enable = true;
        system.enable = true;
        thumbnails.enable = true;
        time.enable = true;
        zramswap.enable = true;
      };
      ai.enable = true;
      application.enable = true;
      audio.enable = true;
      cli.enable = true;
      core.enable = true;
      desktop.hyprland.enable = true;
      fonts.enable = true;
      gaming.enable = true;
      gaming.stream-host.enable = true;
      gc.enable = true;
      keyring.enable = true;
      rdp.client.enable = true;
      rice.enable = true;
      secrets.enable = true;
      sync.enable = true;
      systemd.enable = true;
      torrent.enable = true;
      tweag.enable = true;
    };
    programs = {
      comfyui.enable = true;
      librewolf.enable = true;
      pipewire.higherQuantum.enable = true;
    };
    hardware = {
      gpu.nvidia.rtx3070.enable = true;
      peripheral.logitech = {
        g903.enable = true;
        g903.id = "046d:c539";
        g915.enable = true;
        g935.enable = true;
      };
      peripheral.xbox.one.controller.enable = true;
      cpu.intel.comet-lake.enable = true;
      disk.enable = true;
    };
    gaming.minecraft.servers = {
      enable = true;
      dataDir = "/srv/minecraft";
      worlds.poketards.enable = true;
    };
    gaming.gamescope.args = [
      "--adaptive-sync"
      "-O ${monitors.left}"
      "-W 1920"
      "-H 1080"
      "-r 165"
    ];
  };

  shared.imports = lib.optionals (hostname == host.name) [
    ./restic.nix
    ./ssh.nix
  ];

  homeManager = {
    home.packages = [ pkgs.megasync ];
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
      settings.folders."${config.home.homeDirectory}/Documents/Notes".path =
        "/mnt/oldone/Filen/Area/Notes";
      guiCredentials.passwordFile = config.sops.secrets.titanium-syncthing-password.path;
    };
    sops.secrets.titanium-syncthing-password = {
      sopsFile = ../../secrets/titanium-syncthing-password.txt;
      mode = "400";
      format = "binary";
    };
  };

  nixos = {
    imports = lib.optionals (hostname == host.name) (
      [
        ./hardware-configuration.nix
        inputs.disko.nixosModules.disko
        ./disks
        "${inputs.nixos-hardware}/common/gpu/nvidia/ampere"
      ]
      ++ builtins.attrValues {
        inherit (inputs.nixos-hardware.nixosModules)
          common-pc
          common-pc-ssd
          ;
      }
    );

    services.sunshine = {
      settings.output_name = "DP-2";
      applications.apps =
        let
          dispatchers = import ../../modules/programs/hyprland/dispatchers.nix { inherit lib; };
          detached = pkgs.writeShellScript "sunshine-steam-detached" ''
            ${
              dispatchers.toCmd (
                dispatchers.window.move {
                  initialclass = "steam";
                  workspace = "10";
                  follow = true;
                }
              )
            } || true

            ${dispatchers.toCmd (
              dispatchers.exec_cmdr "setsid steam steam://open/bigpicture" {
                workspace = "10";
                monitor = monitors.left;
              }
            )}
          '';
        in
        [
          {
            name = "Steam Big Picture (dedicated workspace)";
            detached = [
              detached.outPath
            ];
            prep-cmd = [
              {
                do = "";
                undo = "setsid steam steam://close/bigpicture";
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
}
