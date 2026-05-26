{
  lib,
  config,
  inputs,
  util,
  ...
}:
let
  sops.age = {
    keyFile = "${config.gipphe.homeDirectory}/.config/sops/age/keys.txt";
    generateKey = false;
  };
in
util.mkModule {
  options.gipphe.environment.secrets = {
    enable = lib.mkEnableOption "secret management with sops-nix";
  };

  homeManager = {
    imports = [ inputs.sops-nix.homeManagerModules.sops ];
    inherit sops;
    programs.fish.shellInit = # fish
      ''
        set -gx SECRETS_DIR $XDG_RUNTIME_DIR
      '';
  };
  nixos = {
    imports = [ inputs.sops-nix.nixosModules.sops ];
    inherit sops;
  };
}
