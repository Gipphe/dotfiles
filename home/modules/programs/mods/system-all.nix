{ lib, config, ... }:
let
  inherit (config.gipphe) username;
in
{
  config = lib.mkIf config.gipphe.programs.mods.enable {
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
