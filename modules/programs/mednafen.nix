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
      #
      # Extract .chd files with `ghcman extractcd -i "<name>.chd" -o
      # "<name>.cue" -ob "<name>.bin"`.
      #
      # Bundle the resulting .cue and .bin files into a .zip with `zip
      # "<name>.zip" "<name>.bin" "<name>.cue"`.
      # TODO: make a convenience script for rebundling .chd into .zip.
      home = {
        packages = [
          pkgs.mednafen
          pkgs.mednaffe
        ];
      };
      sops = {
        inherit secrets;
      };
    };
}
