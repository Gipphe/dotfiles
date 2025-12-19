{
  lib,
  config,
  pkgs,
  flags,
  ...
}:
let
  cfg = config.gipphe.programs.fish;
  tomlFormat = pkgs.formats.toml { };
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

        gipphe.windows.home.file.".config/starship.toml".source =
          tomlFormat.generate "starship-config-windows"
            (
              lib.recursiveUpdate config.programs.starship.settings {
                custom = {
                  git_branch.when = "! jj --ignore-working-copy root";
                  git_status.when = "! jj --ignore-working-copy root";
                  jj.when = "jj --ignore-working-copy root";
                  jj.command =
                    let
                      stringParts = lib.splitString " " config.programs.starship.settings.custom.jj.command;
                    in
                    lib.concatStringsSep " " ([ "jj" ] ++ builtins.tail stringParts);
                };
              }
            );
      }
      (lib.optionalAttrs (flags.isNixos && flags.stylix) {
        stylix.targets.starship.enable = false;
      })
    ]
  );
}
