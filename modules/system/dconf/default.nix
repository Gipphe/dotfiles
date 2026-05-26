{ util, ... }:
util.mkToggledModule [ "system" ] {
  name = "dconf";
  nixos.programs.dconf.enable = true;
}
