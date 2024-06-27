{
  lib,
  config,
  pkgs,
  ...
}:
let
  variant = "u24n";
in
{
  config = lib.mkIf config.gipphe.system.console.enable {
    console = {
      font = "${pkgs.terminus_font}/share/consolefonts/ter-${variant}.psf.gz";
      earlySetup = true;
    };
  };
}
