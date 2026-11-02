{
  den.aspects.programs.ssh.homeManager =
    { host }:
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      programs.ssh = {
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
              identityFile = config.sensitive.secrets.secrets."${host.hostName}/${name}.ssh";
              addKeysToAgent = "yes";
            }
          )
        );
      };
    };
}
