{ config, lib, ... }:
{

  config = {
    # Necessary for agenix to use ssh host key
    services.openssh.enable = true;

    age.secrets =
      let
        user = {

          owner = "gipphe";
          group = "gipphe";
          mode = "400";
        };
        homeDir = config.users.users.gipphe.home;
        mkSecrets =
          { host, service }:
          {
            "${host}-${service}.ssh.age" = {
              file = ../../secrets/${host}-${service}.ssh.age;
              path = "${homeDir}/.ssh/${service}.ssh";
            } // user;
            "${host}-${service}.ssh.pub.age" = {
              file = ../../secrets/${host}-${service}.ssh.pub.age;
              path = "${homeDir}/.ssh/${service}.ssh.pub";
            } // user;
          };
      in
      mkSecrets config.networking.hostName;

    #   # Actual secrets
    #   age.secrets =
    #     let
    #       user = {
    #         owner = "gipphe";
    #         group = "gipphe";
    #         mode = "400";
    #       };
    #       hosts = [
    #         "nixos-vm"
    #         "trond-arne"
    #       ];
    #       keys = [
    #         "github"
    #         "gitlab"
    #         "codeberg"
    #       ];
    #       suffixes = [
    #         ".ssh"
    #         ".ssh.pub"
    #       ];
    #       combinations = lib.attrsets.cartesianProductOfSets {
    #         host = hosts;
    #         key = keys;
    #         suffix = suffixes;
    #       };
    #       secretsList = map (
    #         {
    #           host,
    #           key,
    #           suffix,
    #         }:
    #         {
    #           name = "${host}-${key}${suffix}";
    #           value = {
    #             file = ../../secrets/${host}-${key}${suffix}.age;
    #             path = "${config.users.users.gipphe.home}/.ssh/${key}${suffix}";
    #           } // user;
    #         }
    #       ) combinations;
    #       secrets = builtins.listToAttrs secretsList;
    #     in
    #     secrets;
  };
}
