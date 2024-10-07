{ util, lib, ... }:
let
  rocksTeamMembers = {
    "adrian" = "adriantr";

    "hanne" = "hanneoyy";
    "sigurd" = "sberglann";
    "mathias" = "mattimoller";
    "tom" = "tpot1";
  };
  teamMemberAliases = lib.foldlAttrs (
    acc: name: username:
    acc
    // {
      "add_${name}" = "pr edit --add-reviewer ${username}";
    }
  ) { } rocksTeamMembers;
in
util.mkProgram {
  name = "gh";
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
        prm = "pr merge --auto -sd";
        addme = "pr edit --add-assignee @me";
        addrocks = "pr edit --add-reviewer strise/rocks";
      } // teamMemberAliases;
    };
  };
}
