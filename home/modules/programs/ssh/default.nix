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

  ssh_secrets = lib.filterAttrs (k: _: lib.hasSuffix ".ssh" k) config.sops.secrets;
  ssh_keys = builtins.concatStringsSep " " (lib.mapAttrsToList (_: v: v.path) ssh_secrets);
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

    programs.fish.functions.add_ssh_keys_to_agent = "ssh-add ${ssh_keys} &>/dev/null";
  };

  system-nixos = lib.mkIf config.gipphe.programs.ssh.enable { programs.ssh.startAgent = true; };
}
