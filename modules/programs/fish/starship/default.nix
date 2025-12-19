{
  lib,
  config,
  pkgs,
  flags,
  ...
}:
let
  cfg = config.gipphe.programs.fish;
in
{
  config = lib.mkIf (cfg.enable && cfg.prompt == "starship") (
    lib.mkMerge [
      {
        programs.starship = {
          enable = true;
          enableTransience = true;
          settings = import ./preset.nix {
            inherit lib;
            inherit (pkgs) jujutsu fetchFromGitHub;
          };
        };
      }
      (lib.optionalAttrs (flags.isNixos && flags.stylix) {
        stylix.targets.starship.enable = false;
      })
    ]
  );
}
