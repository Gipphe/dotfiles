{
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
      cpu.intel.comet-lake.enable = true;
      disk.enable = true;
    };
    gaming.gamescope.args = [
      "--adaptive-sync"
      "-O ${monitors.left}"
      "-W 1920"
      "-H 1080"
      "-r 165"
    ];
  };

  homeManager = {
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
          workspace = "r1";
          default = true;
          monitor = "desc:${monitors.left}";
        }
        {
          workspace = "r9";
          default = true;
          monitor = "desc:${monitors.right}";
        }
      ];
    };
    services = {
      syncthing = {
        settings.folders."${config.home.homeDirectory}/Documents/Notes".path =
          "/mnt/oldone/Filen/Area/Notes";
      };
      restic = {
        enable = true;
        backups.main = {
          repository = "rclone:filen:/Resource/Restic";
          passwordFile = config.sops.secrets.restic-password.path;
          inhibitsSleep = true;
          paths =
            let
              dataPaths = map (p: "${config.xdg.dataHome}/${p}") [
                "dV"
                "PrismLauncher/instances"
                "songsofsyx/saves"
                "Steam/userdata"
                "Steam/steamapps/compatdata"
                "Tachiyomi Backups"
                "zoxide"
                "bolt-launcher/.runelite"
              ];
              configPaths = map (p: "${config.xdg.configHome}/${p}") [
                "EgoSoft/X4/31098541/save"
                "lutris"
              ];
              homePaths = map (p: "${config.home.homeDirectory}/${p}") [
                "Documents"
                "Dwarf Fortress saves"
                "Videos"
              ];
            in
            homePaths ++ configPaths ++ dataPaths;
          exclude =
            let
              steamProtonPaths =
                map (p: "${config.xdg.dataHome}/Steam/steamapps/compatdata/**/pfx/drive_c/${p}")
                  [
                    "*/Common Files"
                    "*/Internet Explorer"
                    "*/Steam"
                    "*/Windows Media Player"
                    "Windows"
                    "windows"
                    "vrclient"
                  ];
            in
            steamProtonPaths
            ++ [
              "${config.xdg.dataHome}/bolt-launcher/.runelite/jagexcache"
              "${config.xdg.dataHome}/bolt-launcher/.runelite/cache"
              "${config.xdg.dataHome}/bolt-launcher/.runelite/logs"
              "${config.xdg.dataHome}/bolt-launcher/.runelite/repository2"
            ];
          pruneOpts = [
            "--compact"
            "--keep-hourly 3"
            "--keep-daily 7"
            "--keep-weekly 4"
            "--keep-monthly 6"
            "--keep-yearly 3"
          ];
          timerConfig = {
            OnCalendar = "daily";
            Persistent = true;
          };
        };
      };
    };

    programs = {
      rclone = {
        enable = true;
        remotes.filen = {
          config.type = "filen";
          secrets = {
            email = config.sops.secrets.filen-email.path;
            password = config.sops.secrets.filen-password.path;
            api_key = config.sops.secrets.filen-api-key.path;
          };
        };
      };
      ssh.settings."sodium.lan" = {
        hostname = "sodium.lan";
        user = "gipphe";
        identityFile = config.sops.secrets."titanium-sodium.ssh".path;
      };
    };

    sops.secrets.restic-password = {
      format = "binary";
      sopsFile = ../../secrets/pub-restic-password.txt;
    };
    sops.secrets.filen-email = {
      format = "binary";
      sopsFile = ../../secrets/pub-filen-email.txt;
    };
    sops.secrets.filen-password = {
      format = "binary";
      sopsFile = ../../secrets/pub-filen-password.txt;
    };
    sops.secrets.filen-api-key = {
      format = "binary";
      sopsFile = ../../secrets/pub-filen-api-key.txt;
    };
    sops.secrets."titanium-sodium.ssh" = {
      format = "binary";
      sopsFile = ../../secrets/titanium-sodium.ssh;
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

    # Required for restic's inhibitSleep
    security.polkit.enable = true;

    services.openssh = {
      enable = true;
      openFirewall = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
        AllowUsers = [ config.gipphe.username ];
        MaxAuthTries = 3;
        PerSourcePenalties = "crash:3600s authfail:3600s max:86400s";
      };
    };

    users.users.${config.gipphe.username}.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJLC+gAQcmXgnkb9seOXdDln/HQkAxxL9s4+hXRJUm0P u0_a342@localhost"
    ];

    hardware.nvidia.prime.nvidiaBusId = "PCI:1@0:0:0";

    system.stateVersion = "26.05";

    boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  };
}
