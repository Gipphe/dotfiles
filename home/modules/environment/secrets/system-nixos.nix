{
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.gipphe.environment.secrets;
  inherit (config.gipphe) username;
in
{
  imports = [ inputs.agenix.nixosModules.age ];
  config = lib.mkIf cfg.enable {
    # Necessary for agenix to use ssh host key
    services.openssh.enable = true;

    # Actual secrets
    age.secrets =
      let
        user = {
          owner = username;
          group = username;
          mode = "400";
        };
        homeDir = config.users.users.${username}.home;
        mkSecrets = host: service: {
          "${host}-${service}.ssh.age" = {
            file = ../../../../secrets/${host}-${service}.ssh.age;
            path = "${homeDir}/.ssh/${service}.ssh";
          } // user;
          "${host}-${service}.ssh.pub.age" = {
            file = ../../../../secrets/${host}-${service}.ssh.pub.age;
            path = "${homeDir}/.ssh/${service}.ssh.pub";
          } // user;
        };
      in
      lib.mkIf cfg.importSecrets (
        builtins.foldl' (acc: curr: acc // mkSecrets config.networking.hostName curr) { } [
          "github"
          "gitlab"
          "codeberg"
        ]
      );
  };
}
