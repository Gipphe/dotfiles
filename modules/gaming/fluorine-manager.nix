{
  util,
  inputs,
  pkgs,
  ...
}:
let
  spt = pkgs.stdenv.mkDerivation (finalAttrs: {
    pname = "sptMO2";
    version = "2.0.0";
    src = pkgs.fetchFromGitHub {
      owner = "Gipphe";
      repo = "sptMO2";
      rev = "389a3d3b9f6e39230e7318bbcaba15f3ae8da006";
      hash = "sha256-A8EOgec2LAEAjiByff0gkdDYQRlRwhCB+p+lEHwUJvU=";
    };
    installPhase = ''
      mkdir -p $out/share
      mv plugins $out/share
    '';
  });
in
util.mkGaming {
  name = "fluorine-manager";
  homeManager.home.packages = [
    (inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.fluorine-manager.override {
      plugins = [ spt ];
    })
  ];
}
