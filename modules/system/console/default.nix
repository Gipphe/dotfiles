{
  util,
  pkgs,
  self,
  ...
}:
util.mkToggledModule [ "system" ] {
  name = "console";
  system-nixos.console = {
    font = "${self.packages.${pkgs.system}.minecraftia-font}/share/consolefonts/minecraftia.psf.gz";
    earlySetup = true;
    keyMap = "no";
  };
}
