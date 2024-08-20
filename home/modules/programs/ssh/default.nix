{
  util,
  lib,
  config,
  pkgs,
  ...
}:
let
  raw_services = [
    "github"
    "gitlab"
    "codeberg"
  ];
  services = builtins.map (x: "${x}.ssh") raw_services;
  mkSecret = service: {
    sopsFile = ../../../../secrets/${config.gipphe.hostName}-${service};
    mode = "400";
    format = "binary";
  };
in
util.mkModule {
  options.gipphe.programs.ssh.enable = lib.mkEnableOption "ssh";

  hm = lib.mkIf config.gipphe.programs.ssh.enable {
    programs.ssh = {
      enable = true;
      package = pkgs.openssh;
      addKeysToAgent = "yes";
      matchBlocks = lib.genAttrs services (s: {
        user = "git";
        identityFile = config.sops.secrets.${s}.path;
        identitiesOnly = true;
      });
    };

    sops.secrets = lib.mkIf config.gipphe.environment.secrets.enable (
      lib.concatMapAttrs (k: v: { ${k} = v; }) (lib.genAttrs services mkSecret)
    );
  };

  system-nixos = lib.mkIf config.gipphe.programs.ssh.enable { programs.ssh.startAgent = true; };
}
