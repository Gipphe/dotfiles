{ util, ... }:
util.mkToggledModule [ "system" ] {
  name = "journald";
  system-nixos.services.journald.extraConfig = ''
    SystemMaxUse=50M
    RuntimeMaxUse=10M
  '';
}
