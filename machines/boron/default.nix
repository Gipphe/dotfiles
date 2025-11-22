{
  pkgs,
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
        bluetooth.enable = true;
        boot-efi.enable = true;
        devices.enable = true;
        networking.enable = true;
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
      gaming.enable = true;
      gc.enable = true;
      keyring.enable = true;
      laptop.enable = true;
      rice.enable = true;
      secrets.enable = true;
      sync.enable = true;
      systemd.enable = true;
      terminal-capture.enable = true;
    };
    programs.pipewire.highQuantum.enable = true;
  };

  hm = {
    wayland.windowManager.hyprland.settings = {
      monitor = [
        ", preferred, auto-down, auto"
      ];
      monitorv2 = [
        {
          output = "desc:Samsung Display Corp. 0x4193";
          mode = "preferred";
          position = "0x0";
          scale = "auto";
        }
      ];
    };

    wayland.windowManager.hyprland.settings.input.kb_layout = lib.mkForce "us";
  };

  system-nixos = {
    imports = lib.optionals (hostname == host.name) [
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-11th-gen
      ./hardware-configuration.nix
    ];

    services.xserver.xkb.layout = lib.mkForce "us";
    console.keyMap = lib.mkForce "us";

    services = {
      auto-cpufreq.enable = true;
      thermald.enable = true;
      logind.settings.Login = {
        HandleLidSwitchExternalPower = "suspend";
        HandleLidSwitchDocked = "ignore";
      };
      tlp.enable = true;
    };
    system.stateVersion = "25.05";
  };
}
