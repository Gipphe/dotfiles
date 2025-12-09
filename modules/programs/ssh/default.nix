{
  util,
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (builtins) map;
  raw_services = [
    "github"
    "gitlab"
    "codeberg"
  ];
  services = map (x: "${x}.ssh") raw_services;
  mkSecret = service: {
    sopsFile = ../../../secrets/${config.gipphe.hostName}-${service};
    mode = "400";
    format = "binary";
  };
in
util.mkProgram {
  name = "ssh";

  hm = {
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
          matchBlocks = lib.genAttrs [ "github.com" "gitlab.com" "codeberg.org" ] (
            hostname:
            let
              inherit (builtins) elemAt split;
              name = elemAt (split "\\." hostname) 0;
            in
            {
              inherit hostname;
              user = "git";
              identityFile = config.sops.secrets."${name}.ssh".path;
              addKeysToAgent = "yes";
            }
          );
        };
      };

      sops.secrets = (
        lib.mkIf config.gipphe.environment.secrets.enable (
          lib.concatMapAttrs (k: v: { ${k} = v; }) (lib.genAttrs services mkSecret)
        )
      );
    };
  };
}
