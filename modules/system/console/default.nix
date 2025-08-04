{ util, pkgs, ... }:
util.mkToggledModule [ "system" ] {
  name = "console";
  system-nixos.console = {
    font = "${pkgs.terminus_font}/share/consolefonts/ter-u24n.psf.gz";
    earlySetup = true;
    keyMap = "no";
  };
}
