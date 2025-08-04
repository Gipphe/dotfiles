{
  util,
  pkgs,
  self,
  ...
}:
util.mkToggledModule [ "system" ] {
  name = "console";
  system-nixos.console = {
    font = "${
      self.packages.${pkgs.system}.monocraft-no-ligatures-font
    }/share/consolefonts/Monocraft-no-ligatures.psf.gz";
    earlySetup = true;
  };
}
