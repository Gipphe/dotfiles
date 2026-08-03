{
  lib,
  config,
  util,
  pkgs,
  ...
}:
let
  cfg = config.programs.carapace;
in
util.mkProgram {
  name = "carapace";
  homeManager = {
    config = {
      programs.carapace = {
        enable = true;
        package = pkgs.symlinkJoin {
          pname = "${pkgs.carapace.pname}-wrapped";
          inherit (pkgs.carapace) version;
          paths = [ pkgs.carapace ];
          nativeBuildInputs = [ pkgs.makeWrapper ];
          postBuild = ''
            wrapProgram $out/bin/carapace \
              --set CARAPACE_BRIDGES fish
          '';
          inherit (pkgs.carapace) meta;
        };
      };
      home.activation.clearCarapaceCache = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        run ${cfg.package}/bin/carapace --clear-cache
      '';
    };
  };
}
