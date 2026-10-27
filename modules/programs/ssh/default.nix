{
  util,
  lib,
  config,
  pkgs,
  ...
}:
util.mkProgram {
  name = "ssh";

  homeManager = {
    options.gipphe.programs.ssh = {
      package = lib.mkPackageOption pkgs "ssh" { } // {
        default = config.programs.ssh.package;
      };
    };

    config = {
      programs = {
        ssh = {
          enable = true;
          package = pkgs.openssh;
          enableDefaultConfig = false;
          settings = lib.filterAttrs (_: x: x.identityFile != null) (
            lib.genAttrs [ "github.com" "gitlab.com" "codeberg.org" ] (
              hostname:
              let
                inherit (builtins) elemAt split;
                name = elemAt (split "\\." hostname) 0;
              in
              {
                inherit hostname;
                user = "git";
                identityFile = config.sensitive.secrets.secrets."${config.gipphe.hostName}/${name}.ssh";
                addKeysToAgent = "yes";
              }
            )
          );
        };
      };
    };
  };
}
