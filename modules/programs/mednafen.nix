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
          def path-to-str []: record -> string {
            $"($in.parent)/($in.stem).($in.extension)"
          }
          def main [
            input: string
            output?: string
          ]: nothing -> nothing {
            let path = $file | path parse
            let tmp = mktemp --directory
            let basename = $file | path basename
            let output_dir = $file | path dirname
            let cue_output = $"($tmp)/($basename | path parse | upsert extension "cue" | path join)"
            let bin_output = $"($tmp)/($basename | path parse | upsert extension "bin" | path join)"
            let zip_output = $output | default {
              $"($tmp)/($basename | path parse | upsert extension "zip" | path join)"
            }
            , chdman extractcd --input $file --output $cue_output --outputbin $bin_output
            ^zip -j $zip_output $cue_output $bin_output
            mv $zip_output $output_dir
            print -e $"Rebundled as ($zip_output)"
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
        autosafe = "1";
      };

      confLine = { name, value }: "| str replace --regex '^${name} .*$' '${name} ${value}'";

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
      home = {
        packages = [
          pkgs.mednafen
          pkgs.mednaffe
          rebundle-chd
          replace-conf-values
        ];
      };
      sops = {
        inherit secrets;
      };
    };
}
