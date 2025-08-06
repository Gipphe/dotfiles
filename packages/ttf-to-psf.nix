{
  runCommandNoCC,
  gnused,
  otf2bdf,
  bdf2psf,
  gzip,
  lib,

  pkg,
  name,
  pointSize ? "24",
  resolution ? "72",
}:
let
  bdf2psf-share = "${bdf2psf}/share/bdf2psf";
  cleanName =
    name
    |> builtins.baseNameOf
    |> lib.splitStringBy (_: x: x == ".") false
    |> lib.reverseList
    |> builtins.tail
    |> lib.reverseList
    |> lib.concatStringsSep ".";
in
runCommandNoCC "minecraftia-psf" { } ''
  echo "otf2bdf"
  (set +e; set +o pipefail; ${otf2bdf}/bin/otf2bdf -v -r ${resolution} -p ${pointSize} -c C "${pkg}/share/fonts/truetype/${name}" |
    ${gnused}/bin/sed -e "s/AVERAGE_WIDTH.*/AVERAGE_WIDTH 80/" > font.bdf
  )

  echo "bdf2psf"
  ${bdf2psf}/bin/bdf2psf font.bdf \
    ${bdf2psf-share}/standard.equivalents \
    ${bdf2psf-share}/ascii.set+${bdf2psf-share}/linux.set+${bdf2psf-share}/useful.set \
    256 \
    font.psf

  echo "gzip"
  ${gzip}/bin/gzip font.psf

  echo "dir"
  mkdir -p $out/share/consolefonts
  mv font.psf.gz $out/share/consolefonts/${cleanName}.psf.gz
''
