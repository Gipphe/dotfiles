{ lib, config, ... }:
{
  options.gipphe.programs.jujutsu.enable = lib.mkEnableOption "jujutsu";
  config = lib.mkIf config.giphe.programs.jujutsu.enable {
    programs.jujutsu = {
      enable = true;
      settings = {
        user = {
          name = "Victor Nascimento Bakke";
          email = "gipphe@gmail.com";
        };
        ui = {
          editor = "nvim";
          default-command = "lol";
        };
        git = {
          auto-local-branch = true;
        };
        aliases = {
          lol = [
            "log"
            "-r"
            "all()"
          ];
          sync = [
            "branch"
            "set"
            "-r"
            "@-"
          ];
        };
      };
    };
  };
}
