{
  lib,
  config,
  pkgs,
  ...
}:
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
        signing = {
          sign-all = true;
          backend = "gpg";
          program = if pkgs.stdenv.isLinux then config.programs.gpg.package else "gpg";
          key = "23723701395B436C";
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
    xdg.configFile."fish/functions/jj.fish".text = # fish
      ''
        function jj
          set -l re "\/strise\/"
          if string match -qr $re $PWD
            ${config.programs.jujutsu.package}/bin/jj --config-toml='signing.key="B4C7E23DDC6AE725"' $argv
          else
            ${config.programs.jujutsu.package}/bin/jj $argv
          end
        end
      '';
  };
}
