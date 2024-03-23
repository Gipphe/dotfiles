{ config, lib, ... }:
let
  cfg = config.secrets.agenix;
in
{
  options.secrets.agenix = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
    importSecrets = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
  };
  config = lib.mkIf cfg.enable {
    # Necessary for agenix to use ssh host key
    services.openssh.enable = true;

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

    age.secrets =
      let
        user = {

          owner = "gipphe";
          group = "gipphe";
          mode = "400";
        };
        homeDir = config.users.users.gipphe.home;
        mkSecrets = host: service: {
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
      lib.mkIf cfg.importSecrets (
        builtins.foldl' (acc: curr: acc // mkSecrets config.networking.hostName curr) { } [
          "github"
          "gitlab"
          "codeberg"
        ]
      );
  };
}
