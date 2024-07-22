{
  util,
  lib,
  config,
  pkgs,
  ...
}:
let
  username = config.gipphe.username;
in
util.mkModule {
  options.gipphe.programs.mods.enable = lib.mkEnableOption "mods";

  hm = lib.mkIf config.gipphe.programs.mods.enable {
    home.packages = [ pkgs.mods ];
    xdg.configFile."mods/mods.yml".source = ./mods.yaml;
    programs.fish.shellInit = ''
      set -gx OPENAI_API_KEY ''$(cat ''$XDG_CONFIG_HOME/mods/key)
    '';
  };

  system-all = lib.mkIf config.gipphe.programs.mods.enable {
    age.secrets = lib.mkIf (with config.gipphe.environment.secrets; enable && importSecrets) {
      "mods-cli-openai-api-key.age" = {
        file = ../../../../secrets/mods-cli-openai-api-key.age;
        path = "${config.home-manager.users.${config.gipphe.username}.xdg.configHome}/mods/key";
        owner = username;
        group = username;
        mode = "400";
      };
    };
  };
}
