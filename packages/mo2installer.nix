{
  lib,
  fetchurl,
  stdenv,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "mo2installer";
  version = "7.0.0-rc5";
  src = fetchurl {
    url = "https://github.com/Furglitch/modorganizer2-linux-installer/releases/download/${finalAttrs.version}/mo2-lint";
    hash = "sha256-l6w/Q0V8OUZPuy2Wh6I2ePqB0UjaefO3m28UqVQUX88=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir -p "$out/bin"
    cp "$src" "$out/bin/${finalAttrs.meta.mainProgram}"
    chmod +x "$out/bin/${finalAttrs.meta.mainProgram}"
  '';

  meta = {
    description = "An easy-to-use Mod Organizer 2 installer for Linux";
    homepage = "https://github.com/Furglitch/modorganizer2-linux-installer";
    license = lib.licenses.gpl3Only;
    mainProgram = "mo2-lint";
    platforms = lib.platforms.linux;
  };
})
