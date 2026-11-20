{
  den.aspects.programs.mednafen.homeManager =
    { pkgs, lib, ... }:
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
          pkgs.make-tools
          pkgs.zip
        ];
        text = /* nu */ ''
          def path-to-str []: record -> string {
            $"($in.parent)/($in.stem).($in.extension)"
          }
          def main [file: string ]: nothing -> nothing {
            let path = $file | path parse
            let cue_output = $path | upsert extension "cue" | path-to-str
            let bin_output = $path | upsert extension "bin" | path-to-str
            chdman extractcd --input $file --output $cue_output --outputbin $bin_output
            let zip_output = $path | upsert extension "zip" | path-to-str
            zip $zip_output $cue_output $bin_output
            print -e $"Rebundled as ($zip_output)"
          }
        '';
      };
    in
    {
      # Set the following config in `~/.mednafen/mednafen.cfg` if no audio is
      # playing:
      #     sound.driver alsa
      #     sound.device sexyal-literal-default
      #
      # Enable caching entire CD contents into memory (necessary to run games from .zip):
      #     cd.image_memcache 1
      #
      # Automatically save and load game state:
      #     autosave 1
      home = {
        packages = [
          pkgs.mednafen
          pkgs.mednaffe
          rebundle-chd
        ];
      };
      sops = {
        inherit secrets;
      };
    };
}
