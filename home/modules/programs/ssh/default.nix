{
  util,
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.gipphe.environment.secrets;
  inherit (config.gipphe) username;
in
util.mkModule {
  options.gipphe.programs.ssh.enable = lib.mkEnableOption "ssh";
  hm = lib.mkIf config.gipphe.programs.ssh.enable {
    programs.ssh = {
      enable = true;
      package = pkgs.openssh;
      addKeysToAgent = "yes";
      matchBlocks = {
        "github.com" = {
          user = "git";
          identityFile = "${config.home.homeDirectory}/.ssh/github.ssh";
          identitiesOnly = true;
        };
        "gitlab.com" = {
          user = "git";
          identityFile = "${config.home.homeDirectory}/.ssh/gitlab.ssh";
          identitiesOnly = true;
        };
        "codeberg.org" = {
          user = "git";
          identityFile = "${config.home.homeDirectory}/.ssh/codeberg.ssh";
          identitiesOnly = true;
        };
      };
    };
  };
  system-nixos = lib.mkIf config.gipphe.programs.ssh.enable { programs.ssh.startAgent = true; };
  system-all = lib.mkIf (config.gipphe.programs.ssh.enable && cfg.importSecrets) {
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
      builtins.foldl' (acc: curr: acc // mkSecrets config.networking.hostName curr) { } [
        "github"
        "gitlab"
        "codeberg"
      ];
  };
}
