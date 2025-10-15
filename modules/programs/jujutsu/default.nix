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
          default-command = "status";
          diff-editor = ":builtin";
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
              set -l bookmarks (${lib.getExe cfg.package} bookmark list -T 'name ++ "\n"')
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
          pub-change = [

            "git"
            "push"
            "--change"
            "@"
          ];
          pub =
            let
              script = util.writeFishApplication {
                name = "jj-pub";
                runtimeInputs = [
                  cfg.package
                  pkgs.coreutils
                  config.gipphe.programs.git.package
                  config.gipphe.programs.ssh.package
                ];
                text =
                  # fish
                  ''
                    argparse h/help r/revision= -- $argv
                    or exit 1

                    function info
                      echo $argv >&2
                    end

                    if set -ql _flag_help
                      info "jj-pub [-h|--help] [-r|--revision <jj-revision>]"
                      info "  -r or --revision REVISION"
                      info "    Revision to publish. Defaults to @"
                      info "  -h or --help"
                      info "    Show this help text"
                      exit 0
                    end

                    set -l rev @
                    if set -ql _flag_revision
                      set rev $_flag_revision
                    end
                    set -l desc (jj show --template description --no-patch "$rev" | head -n 1)
                    or exit 1

                    if test -z "$desc"
                      info "Found no description to base bookmark name on"
                      exit 1
                    end

                    if test "$(string replace -ra '[^:]+' "" "$desc")" = ":"
                      set desc (string replace -r '\\)?: ' '/' $desc | string replace -ra '[^\\w/]' '-' | string lower)
                      set desc (echo -n "$desc" | tr -sc '/:[:alnum:]' '-' | tr -s ':' '/')
                    else
                      # Fall back to "gipphe/push-<short_id>" if no description
                      # is set, or description does not comply with
                      # conventional commits.
                      set desc "gipphe/push-$(jj show --template short_id --no-path "$rev")"
                    end

                    jj bookmark create -r "$rev" "$desc"
                    jj git push --bookmark "$desc" --allow-new
                  '';
              };
            in
            [
              "util"
              "exec"
              "--"
              (lib.getExe' script "jj-pub")
            ];
          fixup = [
            "squash"
            "--use-destination-message"
            "--into"
          ];
          get-desc = [
            "util"
            "exec"
            "--"
            (lib.getExe pkgs.dash)
            "--no-config"
            "-c"
            ''
              ${lib.getExe' cfg.package "jj"} show --template 'description' --no-patch | ${pkgs.wl-clipboard}/bin/wl-copy
            ''
          ];
        };
        "--scope" = [
          {
            "--when".repositories = [
              "~/projects/tweag"
              "~/projects/modus-create"
            ];
            user.email = "victor.bakke@tweag.io";
          }
        ];
      };
    };
    sops.secrets."git-ssh-signing-key.pub" = {
      format = "binary";
      sopsFile = ../../../secrets/pub-git-ssh-signing-key.pub;
    };
  };
}
