{
  util,
  hostname,
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
        boot-efi.enable = true;
        devices.enable = true;
        system.enable = true;
      };
      ai.enable = true;
      application.enable = true;
      audio.enable = true;
      cli.enable = true;
      core.enable = true;
      desktop.plasma.enable = true;
      fonts.enable = true;
      gaming.enable = true;
      gc.enable = true;
      networkmanager.enable = true;
      rice.enable = true;
      secrets.enable = true;
      sync.enable = true;
      systemd.enable = true;
      vm-guest.enable = true;
      windows-setup.enable = true;
    };
  };
  system-nixos.imports = lib.optionals (hostname == host.name) [ ./hardware-configuration.nix ];
}
