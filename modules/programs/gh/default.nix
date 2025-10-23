{
  util,
  lib,
  config,
  ...
}:
util.mkProgram {
  name = "gh";
  options.gipphe.programs.gh.settings.aliases = lib.mkOption {
    type = with lib.types; attrsOf str;
    default = { };
  };
  hm.programs.gh = {
    enable = true;
    settings = {
      editor = "";
      prompt = "enabled";
      pager = "";
      http_unix_socket = "";
      browser = "";
      git_protocol = "https";
      aliases = {
        co = "pr checkout";
        prc = "pr create -d --fill-first --assignee @me --no-maintainer-edit";
        jprc =
          let
            script = util.writeFishApplication {
              name = "gh-pr-create-jj";
              runtimeInputs = [ config.programs.jj.package ];
              text = /* fish */ ''
                argparse h/help r/rev= -- $argv
                or exit 1

                function info
                  echo $argv >&2
                end

                if set -ql _flag_h
                  info "Usage: gh prc [...args]"
                  info "    Create PR for a given Git branch or jj bookmark."
                  info "    Defaults to the current branch or current revision's bookmark if none is specified."
                  info "Args:"
                  info "    -r|--rev"
                  info "        Specify jj revision or git branch to create PR for."
                  info "    -h|--help"
                  info "        Show this help text."
                  exit 0
                end

                function prc
                  set -l extra_args
                  if set -ql _flag_rev
                    set -a extra_args --head $_flag_rev
                  end
                  gh pr create -d --fill-first --assignee @me --no-maintainer-edit $extra_args
                end

                function jprc
                  set -l rev $_flag_rev
                  if test -z "$rev"
                    set rev "@"
                  end
                  set -l b (jj show "$rev" -T 'local_bookmarks' --no-patch | string split ' ')
                  or exit 1
                  if test (count $b) -gt 1
                    info "Revision has more than 1 bookmark. Unable to determine which bookmark you want to create PR for."
                    exit 1
                  end
                  if test (count $b) -lt 1
                    info "Revision has no bookmark."
                    exit 1
                  end
                  
                  gh pr create -d --fill --assignee @me --no-maintainer-edit --head "$b"
                end

                if test -d .jj
                  jprc
                else
                  prc
                end
              '';
            };
          in
          "pr create -d --fill";
        prm = "pr merge --auto -sd";
        addme = "pr edit --add-assignee @me";
      }
      // config.gipphe.programs.gh.settings.aliases;
    };
  };
}
