{
  lib,
  config,
  util,
  pkgs,
  ...
}:
let
  cfg = config.gipphe.programs.carapace;
  hmCfg = config.programs.carapace;
in
util.mkProgram {
  name = "carapace";
  options.gipphe.programs.carapace = {
    specs = lib.mkOption {
      description = ''
        Custom Carapace specs to include. Will be converted to YAML, using the
        attr name as the final file name for the spec.
      '';
      default = { };
      type = lib.types.attrsOf (pkgs.formats.yaml { }).type;
    };
  };
  homeManager = {
    config = {
      programs = {
        carapace = {
          enable = true;
          package = pkgs.symlinkJoin {
            pname = "${pkgs.carapace.pname}-wrapped";
            inherit (pkgs.carapace) version;
            paths = [ pkgs.carapace ];
            nativeBuildInputs = [ pkgs.makeWrapper ];
            postBuild = ''
              wrapProgram $out/bin/carapace \
                --set CARAPACE_BRIDGES fish,zsh
            '';
            inherit (pkgs.carapace) meta;
          };
        };
        # Keep these for extra completions for programs that don't have native
        # nushell completions.
        fish.enable = true;
        zsh.enable = true;
        zsh.dotDir = "${config.xdg.configHome}/zsh";
      };
      home.activation.clearCarapaceCache = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        run ${hmCfg.package}/bin/carapace --clear-cache
      '';
      xdg.configFile =
        let
          yamlFormat = pkgs.formats.yaml { };
        in
        lib.mapAttrs' (name: value: {
          name = "carapace/specs/${name}.yaml";
          value.source = yamlFormat.generate "carapace-spec-${name}.yaml" value;
        }) cfg.specs;
    };
  };
}
