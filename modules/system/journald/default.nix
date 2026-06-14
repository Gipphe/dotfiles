{ util, ... }:
util.mkToggledModule [ "system" ] {
  name = "journald";
  nixos.services.journald.extraConfig = ''
    SystemMaxUse=2000M
    RuntimeMaxUse=500M
  '';
}
