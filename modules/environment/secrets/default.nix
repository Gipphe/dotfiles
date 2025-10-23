{
  lib,
  config,
  inputs,
  util,
  ...
}:
util.mkModule {
  options.gipphe.environment.secrets = {
    enable = lib.mkEnableOption "secret management with sops-nix";
  };

  hm = {
    imports = [ inputs.sops-nix.homeManagerModules.sops ];
    sops = {
      age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
    };
    programs.fish.shellInit = # fish
      ''
        set -gx SECRETS_DIR $XDG_RUNTIME_DIR
      '';
  };
  system-nixos = {
    imports = [ inputs.sops-nix.nixosModules.sops ];
    config.sops.age.keyFile = "${config.gipphe.homeDirectory}/.config/sops/age/keys.txt";
  };
}
