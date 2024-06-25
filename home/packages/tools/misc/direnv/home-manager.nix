{ lib, config, ... }:
{
  config = lib.mkIf config.gipphe.programs.direnv.enable {
    programs.direnv = {
      enable = true;
      config = {
        hide_env_diff = true;
      };
      nix-direnv.enable = true;
    };
  };
}
