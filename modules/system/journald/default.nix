{ util, ... }:
util.mkToggledModule [ "system" ] {
  name = "journald";
  nixos.services.journald.extraConfig = ''
    SystemMaxUse=500M
    RuntimeMaxUse=100M
  '';
}
