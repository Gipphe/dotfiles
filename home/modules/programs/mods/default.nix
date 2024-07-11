{
  util,
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
util.mkModule {
  options.gipphe.programs.mods.enable = lib.mkEnableOption "mods";

  hm = lib.mkIf config.gipphe.programs.mods.enable {
    home.packages = [ pkgs.mods ];
    xdg.configFile."mods/mods.yaml".source = ./mods.yaml;
    programs.fish.shellInit = ''
      set -gx OPENAI_API_KEY ''$(''$XDG_CONFIG_HOME/mods/key)
    '';
  };

  system-nixos = lib.mkIf config.gipphe.programs.mods.enable {
    age.secrets = lib.mkIf (with config.gipphe.environment.secrets; enable && importSecrets) {
      "mods-cli-openai-api-key.age" = {
        file = ../../../../secrets/mods-cli-openai-api-key.age;
        path = "${config.home-manager.users.${config.gipphe.username}.xdg.configHome}/mods/key";
      };
    };
  };
}
