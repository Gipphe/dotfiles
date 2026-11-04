{ inputs, ... }: {
  den.aspects.environment.secrets =
    { host, user }:
    let
      sensitive.secrets = {
        enable = true;
        keyFile = "${user.homeDirectory}/.config/sops/age/keys.txt";
        inherit (host) hostName;
      };
    in
    {
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
    };
}
