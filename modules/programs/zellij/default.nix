{ util, ... }:
util.mkProgram {
  name = "zellij";
  homeManager = {
    imports = [ ./config.nix ];
    config.programs = {
      zellij.enable = true;
      nushell.shellAliases = {
        zq = "zellij kill-session $env.ZELLIJ_SESSION_NAME";
        zj = "zellij";
      };
    };
  };
}
