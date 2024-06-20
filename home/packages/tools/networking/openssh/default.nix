{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.gipphe.programs.ssh.enable = lib.mkEnableOption "ssh";
  config = lib.mkIf config.gipphe.programs.ssh.enable {
    programs.ssh = {
      enable = true;
      package = pkgs.ssh;
      addKeysToAgent = "yes";
      matchBlocks = {
        "github.com" = {
          user = "git";
          identityFile = "${config.home.homeDirectory}/.ssh/github.ssh";
          identitiesOnly = true;
        };
        "gitlab.com" = {
          user = "git";
          identityFile = "${config.home.homeDirectory}/.ssh/gitlab.ssh";
          identitiesOnly = true;
        };
        "codeberg.com" = {
          user = "git";
          identityFile = "${config.home.homeDirectory}/.ssh/codeberg.ssh";
          identitiesOnly = true;
        };
      };
    };
  };
}
