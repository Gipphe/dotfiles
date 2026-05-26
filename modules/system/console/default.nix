{ util, pkgs, ... }:
util.mkToggledModule [ "system" ] {
  name = "console";
  nixos.console = {
    font = "${pkgs.terminus_font}/share/consolefonts/ter-u24n.psf.gz";
    earlySetup = true;
  };
}
