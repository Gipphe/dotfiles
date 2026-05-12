{ util, ... }:
util.mkToggledModule [ "system" ] {
  name = "journald";
  system-nixos.services.journald.extraConfig = ''
    SystemMaxUse=500M
    RuntimeMaxUse=100M
  '';
}
