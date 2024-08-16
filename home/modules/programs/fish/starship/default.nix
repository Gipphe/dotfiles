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

    home.activation.copy-starship-config = lib.hm.dag.entryAfter [ "writeBoundary" ] (
      let
        script = pkgs.writeShellApplication {
          name = "starship-config-copy";
          runtimeEnv = {
            from = "${config.xdg.configHome}/starship.toml";
            to = "${config.home.homeDirectory}/projects/dotfiles/windows/Config/starship.toml";
          };
          text = ''
            cp -f "$from" "$to"
          '';
        };
      in
      ''
        run ${lib.getExe script}
      ''
    );
  };
}
