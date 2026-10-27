{
  lib,
  config,
  inputs,
  util,
  ...
}:
let
  sensitive.secrets = {
    enable = true;
    keyFile = "${config.gipphe.homeDirectory}/.config/sops/age/keys.txt";
    inherit (config.gipphe) hostName;
  };
in
util.mkModule {
  options.gipphe.environment.secrets = {
    enable = lib.mkEnableOption "secret management with sops-nix";
  };

  homeManager = {
    imports = [ inputs.secrets.homeModules.default ];
    inherit sensitive;
    programs.nushell.extraConfig = /* nu */ ''
      $env.SECRETS_DIR = $env.XDG_RUNTIME_DIR
    '';
  };
  nixos = {
    imports = [ inputs.secrets.nixosModules.default ];
    inherit sensitive;
  };
}
