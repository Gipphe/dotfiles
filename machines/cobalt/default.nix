{
  lib,
  util,
  hostname,
  inputs,
  ...
}:
let
  name = "cobalt";
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
      gaming.enable = true;
      gc.enable = true;
      keyring.enable = true;
      laptop.enable = true;
      networkmanager.enable = true;
      rice.enable = true;
      secrets.enable = true;
      sync.enable = true;
      systemd.enable = true;
      terminal-capture.enable = true;
    };
  };

  system-nixos.imports = lib.optionals (hostname == name) (
    with inputs.nixos-hardware.nixosModules;
    [
      common-cpu-intel
      common-gpu-amd
      common-pc-laptop
      common-pc-laptop-ssd
    ]
  );
}
