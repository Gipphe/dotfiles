{ lib, config, ... }:
{
  config = lib.mkIf config.gipphe.programs.jujutsu.enable {
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
