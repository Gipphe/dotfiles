{ util, ... }:
util.mkToggledModule [ "machines" ] {
  name = "trond-arne";

  shared.gipphe = {
    username = "gipphe";
    homeDirectory = "/home/gipphe";
    hostName = "trond-arne";
    profiles = {
      nixos = {
        audio.enable = true;
        boot-efi.enable = true;
        devices.enable = true;
        system.enable = true;
      };
      audio.enable = true;
      cli.enable = true;
      core.enable = true;
      desktop-normal.enable = true;
      desktop.enable = true;
      fonts.enable = true;
      gaming.enable = true;
      gc.enable = true;
      networkmanager.enable = true;
      rice.enable = true;
      secrets.enable = true;
      systemd.enable = true;
      windows-setup.enable = true;
    };
  };
}
