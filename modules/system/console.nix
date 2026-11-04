{
  den.aspects.system.console.nixos = { pkgs, ... }: {
    console = {
      font = "${pkgs.terminus_font}/share/consolefonts/ter-u24n.psf.gz";
      earlySetup = true;
    };
  };
}
