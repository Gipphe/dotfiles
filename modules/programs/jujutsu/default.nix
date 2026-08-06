{
  inputs,
  lib,
  util,
  config,
  pkgs,
  ...
}:
util.mkProgram {
  name = "jujutsu";

  homeManager = {
    options.gipphe.programs.jujutsu = {
      package = lib.mkPackageOption pkgs "jujutsu" { } // {
        default = config.wrappers.jujutsu.package;
      };
    };
    imports = [
      (inputs.wlib.lib.getInstallModule {
        name = "jujutsu";
        value = inputs.wlib.lib.wrapperModules.jujutsu;
      })
    ];
    config = {
      wrappers.jujutsu = {
        enable = true;
        settings = {
          user = {
            name = "Victor Nascimento Bakke";
            email = "2266817+Gipphe@users.noreply.github.com";
          };
          ui = {
            editor = "nvim";
            default-command = "status";
            diff-editor = ":builtin";
            merge-editor = "vimdiff";
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
          template-aliases."format_short_signature(signature)" = "signature.email().local()";
          templates.git_push_bookmark = ''"gipphe/push-" ++ change_id.short()'';
          signing = {
            behavior = "own";
            backend = "ssh";
            key = config.sops.secrets.git-signing-key.path;
            backends.ssh = {
              program = "${pkgs.openssh}/bin/ssh-keygen";
              allowed-signers = config.wrappers.git.settings.gpg.ssh.allowedSignersFile;
            };
          };
          revset-aliases = {
            log_branches = "present(@) | trunk()::present(@) | bases | bookmarks | curbookmark::@ | @::nextbookmark | downstream(@, bookmarksandheads)";
            bases = "present(dev) | present(trunk())";
            "downstream(x,y)" = "(x::y) & y";
            bookmarks = "downstream(trunk(), bookmarks())";
            bookmarksandheads = "bookmarks | heads(trunk()::)";
            curbookmark = "latest(bookmarks::@- & bookmarks)";
            nextbookmark = "roots(@:: & bookmarksandheads)";
            default = "present(@) | ancestors(immutable_heads()::, 2) | present(trunk())";
          };
          aliases = {
            lol = [
              "log"
              "-r"
              "all()"
            ];
            bb = {
              definition = [
                "show"
                "--no-patch"
                "-T"
                "local_bookmarks"
                "-r"
              ];
              doc = "Get the bookmark for a revision, if there is one.";
            };
            bn = {
              definition = [
                "util"
                "exec"
                "--"
                (lib.getExe (
                  util.writeNushellApplication {
                    name = "jj-bn";
                    runtimeInputs = [
                      config.gipphe.programs.gh.package
                      config.gipphe.programs.jujutsu.package
                    ];
                    text = /* nu */ ''
                      def main [--revision (-r): string]: nothing -> string {
                        if $revision == null or $revision == "" {
                          error make "Missing revision"
                        }
                        gh pr view (jj bb $revision) | from json | get number
                      }
                    '';
                  }
                ))
              ];
              doc = ''
                Get the PR number for a given revision with a bookmark, if a PR
                for that bookmark exists.
              '';
            };
            rebase-all = [
              "rebase"
              "-s"
              "bookmarks() ~ trunk()"
              "-d"
              "trunk()"
            ];
            p = [
              "git"
              "push"
            ];
            pp = [
              "git"
              "fetch"
            ];
            pa = [
              "git"
              "push"
              "--all"
            ];
            pub =
              let
                script = util.writeNushellApplication {
                  name = "jj-pub";
                  runtimeInputs = [
                    config.gipphe.programs.git.package
                    config.gipphe.programs.ssh.package
                    pkgs.jujutsu
                  ];
                  text = builtins.readFile ./jj-pub.nu;
                };
              in
              [
                "util"
                "exec"
                "--"
                (lib.getExe script)
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
        sopsFile = ../../../secrets/pub-git-ssh-signing-key.pub;
      };
    };
  };
}
