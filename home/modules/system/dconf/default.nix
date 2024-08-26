{ util, ... }:
util.mkToggledModule [ "system" ] {
  name = "dconf";
  system-nixos.programs.dconf.enable = true;
}
