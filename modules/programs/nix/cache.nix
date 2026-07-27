{
  util,
  config,
  lib,
  ...
}:
util.mkModule {
  homeManager = {
    sops.secrets.pub-cachix-gipphe-token = {
      sopsFile = ../../../secrets/pub-cachix-gipphe-token.txt;
      format = "binary";
    };
    programs.nushell.environmentVariables = {
      CACHIX_AUTH_TOKEN = lib.hm.nushell.mkNushellInline "(open ${lib.escapeShellArg config.sops.secrets.pub-cachix-gipphe-token.path})";
    };
  };
  nixos = {
    nix.settings = {
      trusted-substituters = [ "https://gipphe.cachix.org" ];
      trusted-public-keys = [
        "gipphe.cachix.org-1:GeHkB5yyMQkXYCPJ1FqFl8fbtDe6/aSmS9k8c57GetY="
      ];
    };
  };
}
