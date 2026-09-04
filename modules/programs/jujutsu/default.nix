{
  inputs,
  lib,
  util,
  config,
  pkgs,
  ...
}:
let
  module = inputs.wlib.wrappers.jujutsu.eval {
    inherit pkgs;
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
          allowed-signers = config.gipphe.programs.git.settings.gpg.ssh.allowedSignersFile;
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
          "--revision"
          "all()"
        ];
        get = {
          definition = [
            "show"
            "--no-patch"
            "--template"
          ];
          doc = "Get a property for a revision";
        };
        id = {
          definition = [
            "show"
            "--no-patch"
            "--template"
            "change_id"
          ];
          doc = "Get change ID for a revision";
        };
        bb = {
          definition = [
            "show"
            "--no-patch"
            "--template"
            "if(local_bookmarks, local_bookmarks.first().name())"
          ];
          doc = "Get the bookmark for a revision, if there is one.";
        };
        bc = {
          doc = "Create a bookmark for a revision based on its description";
          definition = [
            "util"
            "exec"
            "--"
            (
              let
                pkg = placeholder "out";
              in
              lib.getExe (
                util.writeNushellApplication {
                  name = "jj-bc";
                  runtimeInputs = [ pkg ];
                  text = builtins.readFile ./jj-bc.nu;
                }
              )
            )
          ];
        };
        bn = {
          definition = [
            "util"
            "exec"
            "--"
            (
              let
                pkg = placeholder "out";
              in
              lib.getExe (
                util.writeNushellApplication {
                  name = "jj-bn";
                  runtimeInputs = [
                    config.gipphe.programs.gh.package
                    pkg
                  ];
                  text = /* nu */ ''
                    def main [--revision (-r): string]: nothing -> string {
                      if $revision == null or $revision == "" {
                        error make "Missing revision"
                      }
                      gh pr view --json number --template '{{ .number }}' (jj bb $revision)
                    }
                  '';
                }
              )
            )
          ];
          doc = ''
            Get the PR number for a given revision with a bookmark, if a PR
            for that bookmark exists.
          '';
        };
        rebase-all = [
          "rebase"
          "--source"
          "bookmarks() ~ trunk()"
          "--destination"
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
        pub = [
          "util"
          "exec"
          "--"
          (
            let
              pkg = placeholder "out";
            in
            lib.getExe (
              util.writeNushellApplication {
                name = "jj-pub";
                runtimeInputs = [
                  config.gipphe.programs.git.package
                  config.gipphe.programs.ssh.package
                  pkg
                ];
                text = /* nu */ ''
                  def main [revision: string]: nothing -> string {
                    let bookmark = jj bc $revision
                    jj bookmark track --remote origin $bookmark
                    jj git push --bookmark $bookmark
                    $bookmark
                  }
                '';
              }
            )
          )
        ];
        puf = {
          doc = "Push bookmark, create PR, mark PR as ready, and enable auto-merging of PR";
          definition =
            let
              outer = util.writeNushellApplication {
                name = "jj-full_pub";
                text = /* nu */ ''
                  def main [
                    jj_dir: string
                    --revision(-r): string
                  ] {
                    if $revision == null or $revision == "" {
                      error make "Missing --revision"
                    }
                    let jj = $"($jj_dir)/bin/jj"

                    let bookmark = ^$jj bc $revision

                    (
                      systemd-run 
                        --user 
                        --same-dir 
                        '${lib.getExe inner}' 
                        $jj_dir 
                        $bookmark
                    )
                  }
                '';
              };
              inner = util.writeNushellApplication {
                name = "jj-full_pub-inner";
                runtimeInputs = [ config.gipphe.programs.gh.package ];
                text = /* nu */ ''
                  def main [
                    jj_dir: string
                    bookmark: string
                  ] {
                    let jj = $"($jj_dir)/bin/jj"
                    ^$jj pub $bookmark
                    gh pr create --fill-first --no-maintainer-edit --assignee '@me' -H $bookmark
                    gh pr merge --auto --squash --delete-branch $bookmark
                  }
                '';
              };
            in
            [
              "util"
              "exec"
              "--"
              (lib.getExe outer)
              (placeholder "out")
            ];
        };
        fixup = [
          "squash"
          "--use-destination-message"
          "--into"
        ];
      };
    };
  };
in
util.mkProgram {
  name = "jujutsu";

  homeManager = {
    options.gipphe.programs.jujutsu = {
      package = lib.mkPackageOption pkgs "jujutsu" { } // {
        default = module.config.wrapper;
      };
    };
    config = {
      home.packages = [ module.config.wrapper ];
      programs.nushell = {
        extraConfig = ''
          source ${inputs.nu_scripts}/custom-completions/jj/jj-completions.nu
        '';
      };
      sops.secrets."git-ssh-signing-key.pub" = {
        format = "binary";
        sopsFile = ../../../secrets/pub-git-ssh-signing-key.pub;
      };
    };
  };
}
