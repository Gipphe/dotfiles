{
  buildNpmPackage,
  makeWrapper,
  nodejs,
  fetchFromGitHub,
  lib,
}:
let
  version = "3.3.0";
in
buildNpmPackage {
  pname = "jdenticon";
  inherit version;
  src = fetchFromGitHub {
    owner = "dmester";
    repo = "jdenticon";
    rev = version;
    hash = "sha256-uOPNsfEreC7F+Y0WWmudZSPnGxqarna0JPOwQyK6LiQ=";
  };
  npmDepsHash = "sha256-LXwvb088oHmA57EryfYtKi0L/9sB+yyUr/K/qGA1W9k=";

  nativeBuildInputs = [
    makeWrapper
    nodejs
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/lib/jdenticon" "$out/bin"
    cp -r bin dist node_modules "$out/lib/jdenticon"
    makeWrapper "${lib.getExe nodejs}" "$out/bin/jdenticon" \
      --add-flags "$out/lib/jdenticon/bin/jdenticon.js"

    runHook postInstall
  '';

  meta = with lib; {
    changelog = "https://github.com/dmester/jdenticon/releases/tag/${version}";
    description = "JavaScript library for generating highly recognizable identicons using HTML5 canvas or SVG.";
    homepage = "https://jdenticon.com/";
    license = licenses.mit;
    maintainers = with maintainers; [ gipphe ];
    mainProgram = "jdenticon";
  };
}
