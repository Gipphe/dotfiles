{ util, ... }:
util.mkProgram {
  name = "direnv";

  homeManager.programs.direnv = {
    enable = true;
    config = {
      strict_env = true;
      hide_env_diff = true;
      warn_timeout = "0s";
    };
    nix-direnv.enable = true;
  };
}
