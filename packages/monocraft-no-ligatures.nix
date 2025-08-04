{
  callPackage,
  linkFarm,
  fetchurl,
}:
let
  monocraft-no-ligatures-unwrapped = fetchurl {
    url = "https://github.com/IdreesInc/Monocraft/releases/download/v4.1/Monocraft-no-ligatures.ttc";
    hash = "sha256-6FhJr3KK0SCw0W+HPsNoOONm4i5ubYI8K467GOE/BAc=";
  };
  monocraft-no-ligatures = linkFarm "monocraft-no-ligatures" [
    {
      name = "share/fonts/truetype/Monocraft-no-ligatures.ttc";
      path = monocraft-no-ligatures-unwrapped;
    }
  ];
in
callPackage ./ttf-to-psf.nix {
  name = "Monocraft-no-ligatures.ttc";
  pkg = monocraft-no-ligatures;
}
