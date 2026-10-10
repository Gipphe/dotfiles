{
  fetchurl,
  lib,
  appimageTools,
}:
let
  pname = "jagex-launcher";
  version = "0.0.27";

  src = fetchurl {
    url = "https://rs-launcher-updates.runescape.com/production/linux/x64/releases/${version}/jagex-launcher-beta-linux-x86_64.AppImage";
    sha256 = "b26cd33e2315681437204cd4eb797107ddb42e3640a854c4fee75a279f02f2a9";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  # Pull the .desktop entry and icons out of the AppImage so the launcher
  # shows up in your application menu, and point Exec= at the wrapper
  # rather than the AppImage's internal AppRun.
  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/${pname}.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=${pname}'
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  meta = {
    description = "Official Jagex Launcher for RuneScape / Old School RuneScape (Linux beta)";
    homepage = "https://www.runescape.com/launcher";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    mainProgram = "jagex-launcher";
  };
}
