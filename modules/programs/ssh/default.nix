{
  util,
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.gipphe.programs.ssh;
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

  options.gipphe.programs.ssh.lovdata.enable = lib.mkEnableOption "Lovdata configs for SSH";

  hm = {
    programs = {
      ssh = {
        enable = true;
        package = pkgs.openssh;
        addKeysToAgent = "yes";
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
          }
        );
      };
    };

    sops.secrets = lib.mkMerge [
      (lib.mkIf config.gipphe.environment.secrets.enable (
        lib.concatMapAttrs (k: v: { ${k} = v; }) (lib.genAttrs services mkSecret)
      ))
      (lib.mkIf cfg.lovdata.enable {
        "lovdata-gitlab.ssh" = mkSecret "lovdata-gitlab.ssh";
      })
    ];
  };
}
