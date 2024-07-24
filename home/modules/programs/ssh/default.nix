{
  util,
  lib,
  config,
  pkgs,
  ...
}:
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

    age.secrets =
      lib.mkIf (config.gipphe.programs.ssh.enable && config.gipphe.environment.secrets.enable)
        (
          let
            homeDir = config.home.homeDirectory;
            mkSecrets = host: service: {
              "${host}-${service}.ssh.age" = {
                file = ../../../../secrets/${host}-${service}.ssh.age;
                path = "${homeDir}/.ssh/${service}.ssh";
                mode = "400";
              };
              "${host}-${service}.ssh.pub.age" = {
                file = ../../../../secrets/${host}-${service}.ssh.pub.age;
                path = "${homeDir}/.ssh/${service}.ssh.pub";
                mode = "400";
              };
            };
          in
          builtins.foldl' (acc: curr: acc // mkSecrets config.gipphe.hostName curr) { } [
            "github"
            "gitlab"
            "codeberg"
          ]
        );
  };

  system-nixos = lib.mkIf config.gipphe.programs.ssh.enable { programs.ssh.startAgent = true; };
}
