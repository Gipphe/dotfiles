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
    programs.fish.shellInit = ''
      if test -f $XDG_CONFIG_HOME/mods/key
        set -gx MODS_OPENAI_API_KEY $(cat $XDG_CONFIG_HOME/mods/key)
      end
    '';

    age.secrets = lib.mkIf (with config.gipphe.environment.secrets; enable && importSecrets) {
      "mods-cli-openai-api-key.age" = {
        file = ../../../../secrets/mods-cli-openai-api-key.age;
        path = "${config.xdg.configHome}/mods/key";
        mode = "400";
      };
    };
  };
}
