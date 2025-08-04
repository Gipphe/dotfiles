{
  runCommandNoCC,
  minecraftia,
  gnused,
  otf2bdf,
  bdf2psf,
  gzip,
}:
let
  bdf2psf-share = "${bdf2psf}/share/bdf2psf";
in
runCommandNoCC "minecraftia-psf" { } ''
  echo "otf2bdf"
  (set +e; set +o pipefail; ${otf2bdf}/bin/otf2bdf -v -r 72 -p 12 -c C "${minecraftia}/share/fonts/truetype/Minecraftia.ttf" |
    ${gnused}/bin/sed -e "s/AVERAGE_WIDTH.*/AVERAGE_WIDTH 80/" > minecraftia.bdf
  )

  echo "bdf2psf"
  ${bdf2psf}/bin/bdf2psf minecraftia.bdf \
    ${bdf2psf-share}/standard.equivalents \
    ${bdf2psf-share}/ascii.set+${bdf2psf-share}/linux.set+${bdf2psf-share}/useful.set \
    256 \
    minecraftia.psf

  echo "gzip"
  ${gzip}/bin/gzip minecraftia.psf

  echo "dir"
  mkdir -p $out/share/consolefonts
  mv minecraftia.psf.gz $out/share/consolefonts
''
