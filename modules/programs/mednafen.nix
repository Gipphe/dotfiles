{
  den.aspects.programs.mednafen.homeManager =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    let
      prefix = "scph";
      suffix = ".bin";
      kinds = map toString [
        5500
        5501
        5502
      ];
      secrets = builtins.listToAttrs (
        builtins.attrValues (
          lib.genAttrs kinds (p: {
            name = "pub/psx-${p}";
            value.path = ".mednafen/${prefix}${p}${suffix}";
          })
        )
      );

      rebundle-chd = pkgs.writeNushellApplication {
        name = "rebundle-chd";
        runtimeInputs = [
          config.gipphe.programs.nix-index.comma.package
          pkgs.zip
        ];
        text = /* nu */ ''
          def main [
            input: string # Input `.chd` file to rebundle.
            output?: string # Output path for `.zip` bundle. Defaults to same directory as `input`.
          ]: nothing -> nothing {
            let abs_input = $input | path expand
            let path = $abs_input | path parse
            let tmp = mktemp --directory
            let basename = $abs_input | path basename
            let cue_output = $"($tmp)/($basename | path parse | upsert extension "cue" | path join)"
            let bin_output = $"($tmp)/($basename | path parse | upsert extension "bin" | path join)"

            let zip_output = if $output == null {
              $"($abs_input | path dirname)/($basename | path parse | upsert extension "zip" | path join)"
            } else if ($output | path type) == dir {
              $"($output)/($basename | path parse | upsert extension "zip" | path join)"
            } else if ($output | path exists) and ($output | path type) != "dir"  {
              error make $"Output file ($output) already exists"
            } else {
              $output
            }

            try {
              , chdman extractcd --input $abs_input --output $cue_output --outputbin $bin_output
              mkdir ($zip_output | path dirname)
              ^zip -j $zip_output $cue_output $bin_output
              print -e $"Rebundled as ($zip_output)"
            } catch { |e|
              print -e $"Failed: ($e)"
            } finally {
              rm -rf $tmp
            }
          }
        '';
      };
      conf = {
        # Set the following config if no audio is playing.
        "sound.driver" = "alsa";
        "sound.device" = "sexyal-literal-default";

        # Enable caching entire CD contents into memory (necessary to run games from .zip).
        "cd.image_memcache" = "1";

        # Automatically save and load game state.
        autosave = "1";
      };

      confLine = { name, value }: "| str replace --multiline --regex '^${name} .*$' '${name} ${value}'";

      replace-conf-values = pkgs.writeNushellApplication {
        name = "mednafen-replace-conf-values";
        text = /* nu */ ''
          let tmp = mktemp
          let conf_path = '${config.home.homeDirectory}/.mednafen/mednafen.cfg'
          open --raw $conf_path
          ${lib.concatStringsSep "\n" (map confLine (lib.attrsToList conf))}
          | save -f $tmp

          mv $tmp $conf_path
        '';
      };
    in
    {
      gipphe.programs.gipphe.commands.mednafen.rebundle-chd.cmd = lib.getExe rebundle-chd;
      home = {
        packages = [
          pkgs.mednafen
          pkgs.mednaffe
        ];
        activation.mednafen-apply-config = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          run '${lib.getExe replace-conf-values}'
        '';
      };
      sops = {
        inherit secrets;
      };
    };
}
