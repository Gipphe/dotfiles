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
      #
      # sound.driver alsa
      # sound.device sexyal-literal-default
      #
      # Enable caching entire CD contents into memory (necessary to run games from .zip)
      # cd.image_memcache 1
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
