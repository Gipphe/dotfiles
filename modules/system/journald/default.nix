{ util, ... }:
util.mkToggledModule [ "system" ] {
  name = "journald";
  nixos.services.journald.settings.Journal = {
    SystemMaxUse = "2000M";
    RuntimeMaxUse = "500M";
  };
}
