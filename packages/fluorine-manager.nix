{
  lib,
  stdenv,
  fetchzip,
  autoPatchelfHook,
  makeWrapper,
  gtk3,
  libGL,
  libGLX,
  libX11,
  openssl,
  libxcrypt-legacy,
  libxkbcommon,
  python312,
  qt6,
  tcl-9_0,
  tcl9Packages,
  plugins ? [ ],
}:
let
  python = python312.withPackages (
    ps:
    builtins.attrValues {
      inherit (ps)
        # larian-formats # Needed for BG3
        lzallright # Substitute for lzokay
        psutil
        pyyaml
        vdf
        ;
    }
  );
in
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
    openssl
    libxcrypt-legacy
    libxkbcommon
    python
    qt6.qtbase
    tcl-9_0
    tcl9Packages.tk
  ];
  installPhase = ''
    runHook preInstall

    mkdir -p "$out"
    install -D ModOrganizer-core "$out/bin/${finalAttrs.pname}"
    mkdir -p "$out/share"
    mkdir -p "$out/share/applications"
    mkdir -p "$out/share/metainfo"
    mv icons plugin_data plugins python qt.conf qt6plugins stylesheets "$out/share"
    mv lib "$out"
    mv $out/share/icons/*.desktop $out/share/applications
    mv $out/share/icons/*.metainfo.xml $out/share/metainfo

    ${builtins.concatStringsSep "\n" (
      map (plugin: ''
        cp -r ${plugin}/share/plugins/* $out/share/plugins
      '') plugins
    )}

    substituteInPlace $out/share/applications/*.desktop \
      --replace-fail 'Icon=com.fluorine.manager' "Icon=${placeholder "out"}/share/icons/com.fluorine.manager.png"

    ln -s ${python}/bin/python3 "$out/bin/python3"

    runHook postInstall
  '';
  postFixup = ''
    wrapProgram $out/bin/${finalAttrs.pname} \
      --set QT_PLUGIN_PATH "$out/share/qt6plugins" \
      --set MO2_PLUGINS_DIR "$out/share/plugins" \
      --set MO2_LIBS_DIR "$out/lib" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ openssl ]}"
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
