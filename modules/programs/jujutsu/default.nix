{
  util,
  config,
  pkgs,
  ...
}:
util.mkProgram {
  name = "jujutsu";

  hm = {
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
          auto-local-bookmark = true;
        };
        signing = {
          behavior = "own";
          backend = "ssh";
          key = config.sops.secrets."git-ssh-signing-key.pub".path;
          backends.ssh = {
            program = "${pkgs.openssh}/bin/ssh-keygen";
            allowed-signers = config.xdg.configFile."git/allowed_signers".source.outPath;
          };
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
    sops.secrets."git-ssh-signing-key.pub" = {
      format = "binary";
      sopsFile = ../../../secrets/git-ssh-signing-key.pub;
    };
  };
}
