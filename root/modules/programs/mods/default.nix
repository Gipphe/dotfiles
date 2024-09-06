{
  util,
  config,
  pkgs,
  lib,
  ...
}:
util.mkModule {
  options.gipphe.programs.mods.enable = lib.mkEnableOption "mods";
  hm = lib.mkIf config.gipphe.programs.mods.enable {
    home.packages = [ pkgs.mods ];
    xdg.configFile."mods/mods.yml".source = ./mods.yaml;
    programs.fish.shellInit = # fish
      ''
        set -l mods_key_path "${config.sops.secrets."mods-cli-openai-api.key".path}"
        if test -f $mods_key_path
          set -gx MODS_OPENAI_API_KEY $(cat $mods_key_path)
        end
      '';

    sops.secrets = lib.mkIf config.gipphe.environment.secrets.enable {
      "mods-cli-openai-api.key" = {
        sopsFile = ../../../../secrets/mods-cli-openai-api.key;
        path = "${config.xdg.configHome}/mods/key";
        mode = "400";
        format = "binary";
      };
    };
  };
}
