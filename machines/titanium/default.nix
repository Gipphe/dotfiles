{
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
util.mkToggledModule [ "machines" ] {
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
        boot-efi.enable = true;
        camera.enable = true;
        devices.enable = true;
        networking.enable = true;
        printing.enable = true;
        system.enable = true;
        thumbnails.enable = true;
        time.enable = true;
      };
      ai.enable = false;
      application.enable = true;
      audio.enable = true;
      cli.enable = true;
      core.enable = true;
      desktop.hyprland.enable = true;
      desktop.hyprland.noctalia.enable = true;
      desktop.plasma.enable = false;
      fonts.enable = true;
      gaming.enable = true;
      gaming.stream-host.enable = true;
      gc.enable = true;
      keyring.enable = true;
      logitech.enable = true;
      rice.enable = true;
      secrets.enable = true;
      sync.enable = true;
      systemd.enable = true;
      terminal-capture.enable = false;
      torrent.enable = true;
    };
    programs.pipewire.higherQuantum.enable = true;
    system.cpu.enable = true;
  };

  hm = {
    wayland.windowManager.hyprland.settings.monitorv2 = [
      {
        output = "desc:${monitors.left}";
        mode = "preferred";
        position = "0x0";
        scale = 1;
      }
      {
        output = "desc:${monitors.right}";
        mode = "preferred";
        position = "auto-right";
        scale = 1;
      }
    ];
  };

  system-nixos = {
    imports = lib.optionals (hostname == host.name) (
      [
        ./hardware-configuration.nix
        {
          imports = [
            inputs.disko.nixosModules.disko
            ./disk-config.nix
          ];
        }

        # "${inputs.nixos-hardware}/common/gpu/nvidia/ampere"
      ]
      ++ builtins.attrValues {
        inherit (inputs.nixos-hardware.nixosModules)
          common-cpu-intel
          common-gpu-intel-comet-lake
          # common-gpu-nvidia
          common-pc
          common-pc-ssd
          ;
      }
    );

    system.stateVersion = "26.05";
  };
}
