{
  inputs,
  lib,
  config,
  ...
}:
{
  imports = [ inputs.agenix.nixosModules.age ];
  config = lib.mkIf config.gipphe.programs.mods.enable {
    age.secrets = lib.mkIf (with config.gipphe.environment.secrets; enable && importSecrets) {
      "mods-cli-openai-api-key.age" = {
        file = ../../../../secrets/mods-cli-openai-api-key.age;
        path = "${config.home-manager.users.users.${config.gipphe.username}.xdg.configHome}/mods/key";
      };
    };
  };
}
