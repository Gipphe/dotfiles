{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.gipphe.programs.fish;
in
{
  config = lib.mkIf (cfg.enable && cfg.prompt == "starship") {
    programs.starship = {
      enable = true;
      enableTransience = true;
      settings = import ./presets { inherit pkgs lib; };
    };

    gipphe.windows.home.file.".config/starship.toml".source =
      config.home.file.${config.programs.starship.configPath}.source;
  };
}
