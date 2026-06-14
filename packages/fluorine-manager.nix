{
  lib,
  stdenv,
  fetchzip,
  autoPatchelfHook,
  makeWrapper,
  gtk3,
  libGL,
  qt6,
  libGLX,
  libX11,
  libxcrypt-legacy,
  libxkbcommon,
  tcl-9_0,
  tcl9Packages,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "fluorine-manager";
  version = "0.2.3";
  src = fetchzip {
    url = "https://github.com/SulfurNitride/Fluorine-Manager/releases/download/v${finalAttrs.version}/fluorine-manager-${finalAttrs.version}.tar.gz";
    hash = "sha256-resC3qFQM2u4xbAR6N6wohSokX+u3zNNOKJ1BKltBFY=";
  };
  dontWrapQtApps = true;
  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];
  buildInputs = [
    gtk3
    libGL
    libGLX
    libX11
    libxcrypt-legacy
    libxkbcommon
    qt6.qtbase
    tcl-9_0
    tcl9Packages.tk
  ];
  installPhase = ''
    runHook preInstall

    mkdir -p "$out"
    install -D ModOrganizer-core "$out/bin/${finalAttrs.pname}"
    mkdir -p "$out/share"
    mv icons plugin_data plugins python qt.conf qt6plugins stylesheets "$out/share"
    mv lib "$out"

    runHook postInstall
  '';
  postFixup = ''
    wrapProgram $out/bin/${finalAttrs.pname} \
      --set QT_PLUGIN_PATH "$out/share/qt6plugins"
  '';

  meta = {
    description = "A port of MO2 in linux with NaK integration and FUSE based VFS. Comes with Root Builder support by default.";
    homepage = "https://github.com/SulfurNitride/Fluorine-Manager";
    license = lib.licenses.gpl3Only;
    mainProgram = finalAttrs.pname;
    platforms = lib.platforms.linux;
    maintainers = lib.maintainers.gipphe;
  };
})
