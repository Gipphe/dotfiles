{
  lib,
  rustPlatform,
  fetchFromGitHub,
  patchelf,
  pkg-config,

  atk,
  dbus,
  gtk3,
  gtksourceview5,
  libGL,
  libappindicator,
  libayatana-appindicator,
  libglvnd,
  libx11,
  libxcb,
  libxcursor,
  libxi,
  libxkbcommon,
  libxrandr,
  openssl,
  systemdLibs,
  wayland,
  wrapGAppsHook4,
}:
let
  # eframe/winit/glutin `dlopen` these at runtime, so they never show up as
  # NEEDED entries and must be added to the rpath by hand.
  runtimeLibs = [
    libGL
    libappindicator
    libayatana-appindicator
    libglvnd
    libx11
    libxcursor
    libxi
    libxkbcommon
    libxrandr
    wayland
  ];
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "openmouse-bridge";
  version = "1.0.0-beta.20";

  src = fetchFromGitHub {
    owner = "OpenMouse-Project";
    repo = "OpenMouse-Bridge";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aRguHjmwk5Iqd5ar+HGTGpxFrcVCPNBj6z/1GgKVgN4=";
  };

  cargoHash = "sha256-461z9SFtECyCZ2NMLRriKKwCXOXxaqNabfUMJFXkp/o=";

  nativeBuildInputs = [
    patchelf
    pkg-config
    wrapGAppsHook4
  ];
  buildInputs = [
    atk
    dbus
    gtk3
    gtksourceview5
    libxcb
    openssl
    systemdLibs
  ]
  ++ runtimeLibs;

  # winit's Wayland backend can't hide the window, so the panel's close and
  # minimize buttons (which just hide it) do nothing. Force X11/XWayland.
  preFixup = ''
    gappsWrapperArgs+=(--unset WAYLAND_DISPLAY)
  '';

  # /run/opengl-driver/lib provides the system's GPU drivers (NixOS).
  postFixup = ''
    patchelf \
      --add-rpath "${lib.makeLibraryPath runtimeLibs}:/run/opengl-driver/lib" \
      $out/bin/.openmouse-bridge-wrapped
  '';

  meta = {
    description = "A lightweight cross-platform background service for OpenMouse, providing device communication, application detection, and automatic profile switching on Windows and Linux.";
    mainProgram = "openmouse-bridge";
    homepage = "https://github.com/OpenMouse-Project/OpenMouse-Bridge";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.gipphe ];
  };
})
