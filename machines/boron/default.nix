{
  hostname,
  util,
  inputs,
  lib,
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
        biometrics.enable = false;
        bluetooth.enable = true;
        boot-efi.enable = true;
        camera.enable = true;
        networking.enable = true;
        printing.enable = true;
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
      desktop.hyprland.noctalia.enable = true;
      desktop.plasma.enable = false;
      fonts.enable = true;
      gaming.enable = true;
      gc.enable = true;
      keyring.enable = true;
      laptop.enable = true;
      rice.enable = true;
      secrets.enable = true;
      sync.enable = true;
      systemd.enable = true;
      terminal-capture.enable = false;
      torrent.enable = true;
    };
    programs.pipewire.higherQuantum.enable = true;
    system.cpu.enable = true;
    hardware.disk.enable = true;
  };

  hm = {
    gipphe.programs.hyprland.settings.monitors = [
      {
        output = "";
        mode = "preferred";
        position = "auto-down";
        scale = "auto";
      }
      {
        output = "desc:Samsung Display Corp. 0x4193";
        mode = "preferred";
        position = "0x0";
        scale = "auto";
      }
    ];
  };

  system-nixos = {
    imports = lib.optionals (hostname == host.name) [
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-11th-gen
      ./hardware-configuration.nix
    ];

    system.stateVersion = "25.05";
    users = {
      users.gipphe.uid = lib.mkForce null;
      groups.gipphe.gid = lib.mkForce null;
    };
  };
}
