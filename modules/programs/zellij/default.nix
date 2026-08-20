{ inputs, util, ... }:
util.mkProgram {
  name = "zellij";
  homeManager = {
    imports = [ ./config.nix ];
    programs = {
      zellij.enable = true;
      nushell.shellAliases = {
        zq = "zellij kill-session $env.ZELLIJ_SESSION_NAME";
        zj = "zellij";
      };
      nushell.extraConfig = ''
        source ${inputs.nu_scripts}/custom-completions/zellij/zellij-completions.nu
      '';
    };
  };
}
