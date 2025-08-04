{ util, pkgs, ... }:
let
  bdf2psf-share = "${pkgs.bdf2psf}/share/bdf2psf";
  font = pkgs.runCommandNoCC "minecraftia-psf" { } ''
    ${pkgs.otf2bdf}/bin/otf2bdf -r 72 -p 12 -c C "${pkgs.minecraftia}/share/fonts/truetype/Minecraftia.ttf" |
      ${pkgs.gnused}/bin/sed -e "s/AVERAGE_WIDTH.*/AVERAGE_WIDTH 80/" > minecraftia.bdf

    ${pkgs.bdf2psf}/bin/bdf2psf minecraftia.bdf \
      ${bdf2psf-share}/standard.equivalents \
      ${bdf2psf-share}/ascii.set+${bdf2psf-share}/linux.set+${bdf2psf-share}/useful.set \
      256 \
      minecraftia.psf

    ${pkgs.gzip}/bin/gzip minecraftia.psf

    mkdir -p $out/share/consolefonts
    mv minecraftia.psf.gz $out/share/consolefonts
  '';
in
util.mkToggledModule [ "system" ] {
  name = "console";
  system-nixos.console = {
    font = "${pkgs.terminus_font}/share/consolefonts/ter-u24n.psf.gz";
    earlySetup = true;
    keyMap = "no";
  };
}
