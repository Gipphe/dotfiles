{
  util,
  pkgs,
  ...
}:
let
  src = pkgs.fetchzip {
    url = "https://github.com/LibreSprite/LibreSprite/releases/download/v1.1/libresprite-development-macos-arm64.zip";
    hash = "sha256-SmpnZ2La7V0dfvy0jnJKksog9AG7sFXEwcIs4Vo8O3E=";
  };
  pkg = pkgs.runCommandNoCC "libresprite" { src = "${src}"; } ''
    stat "$src"
    ${pkgs._7zz}/bin/7zz x "$src/libresprite.dmg"
    mkdir -p $out/Applications
    mv "libresprite.app" "$out/Applications/Libresprite.app"
  '';
  linuxPackage = pkgs.writeShellApplication {
    name = "libresprite";
    runtimeInputs = [ pkgs.libresprite ];
    text = ''
      libresprite "$@" &>/dev/null &
    '';
  };
  darwinPackage = pkgs.writeShellApplication {
    name = "libresprite";
    text = ''
      open -na "Libresprite.app" --args "$@"
    '';
  };
in
util.mkProgram {
  name = "libresprite";
  hm.home.packages =
    if pkgs.stdenv.isDarwin then
      [
        pkg
        darwinPackage
      ]
    else
      [ linuxPackage ];
}
