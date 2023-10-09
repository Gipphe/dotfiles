final: prev: {
  jujutsu = prev.jujutsu.overrideAttrs (old: rec {
    src = prev.fetchFromGitHub {
      owner = "martinvonz";
      repo = "jj";
      rev = "v0.10.0";
      sha256 = "sha256-FczlSBlLhLIamLiY4cGVAoHx0/sxx+tykICzedFbbx8=";
    };

    cargoDeps = oldAttrs.cargoDeps.overrideAttrs (lib.const {
      name = "jujutsu-vendor.tar.gz";
      inherit src;
      outputHash = "sha256-6ZaaWYajmgPXQ5sbeRQWzsbaf0Re3F7mTPOU3xqY02g=";
    });
  });
}
