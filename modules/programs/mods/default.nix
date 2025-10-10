{
  util,
  config,
  pkgs,
  lib,
  ...
}:
util.mkProgram {
  name = "mods";
  hm = {
    home.packages = [ pkgs.mods ];
    xdg.configFile."mods/mods.yml".source = ./mods.yaml;
    programs.fish = {
      shellInit = # fish
        ''
          set -l mods_key_path "${config.sops.secrets."mods-cli-openai-api.key".path}"
          if test -f $mods_key_path
            set -gx MODS_OPENAI_API_KEY $(cat $mods_key_path)
          end
        '';
      interactiveShellInit = lib.mkAfter ''
        abbr --add "?" -- mods --role shell -q
      '';
    };

    sops.secrets = lib.mkIf config.gipphe.environment.secrets.enable {
      "mods-cli-openai-api.key" = {
        sopsFile = ../../../secrets/pub-mods-cli-openai-api.key;
        path = "${config.xdg.configHome}/mods/key";
        mode = "400";
        format = "binary";
      };
    };
  };
}
