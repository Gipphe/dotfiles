{
  lib,
  util,
  config,
  pkgs,
  ...
}:
let
  cfg = config.programs.jujutsu;
in
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
          diff-editor = [
            "nvim"
            "-c"
            "DiffEditor $left $right $output"
          ];
          merge-editor = "vimdiff";
          pager = [
            "sh"
            "-c"
            "${lib.getExe pkgs.diff-so-fancy} | ${lib.getExe pkgs.less} '--tabs=4' -RFX"
          ];
        };
        colors = {
          "diff removed token".bg = "#221111";
          "diff added token".bg = "#002200";
          "diff token".underline = false;
        };
        diff.color-words = {
          max-inline-alternation = 0;
        };
        merge-tools.vimdiff = {
          merge-args = [
            "-f"
            "-d"
            "$output"
            "-M"
            "$left"
            "$base"
            "$right"
            "-c"
            "wincmd J"
            "-c"
            "set modifiable"
            "-c"
            "set write"
          ];
          program = "nvim";
          diff-invocation-mode = "file-by-file";
          merge-tool-edits-conflict-markers = true;
        };
        git = {
          auto-local-bookmark = false;
        };
        templates.git_push_bookmark = ''"gipphe/push-" ++ change_id.short()'';
        signing = {
          behavior = "own";
          backend = "ssh";
          key = config.sops.secrets.git-signing-key.path;
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
            "util"
            "exec"
            "--"
            (lib.getExe pkgs.fish)
            "--no-config"
            "-c"
            # fish
            ''
              set -l bookmarks (${lib.getExe cfg.package} bookmark list -T name)
              set -l bookmark $argv[1]

              if test -z "$bookmark"
                echo "Missing bookmark argument" >&2
                exit 1
              end

              if not contains $bookmark $bookmarks
                echo "Can only sync existing bookmarks." >&2
                echo "The passed bookmark does not exist: $bookmark" >&2
                exit 2
              end

              ${lib.getExe cfg.package} bookmark set -r @- $bookmark
              exit $status
            ''
          ];
          p = [
            "git"
            "push"
          ];
          pp = [
            "git"
            "fetch"
          ];
          fixup = [
            "squash"
            "--use-destination-message"
            "--into"
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
