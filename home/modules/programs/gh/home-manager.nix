{ lib, config, ... }:
{
  config = lib.mkIf config.gipphe.programs.gh.enable {
    programs.gh = {
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
          prc = "pr create -d --fill-first";
          prm = "pr merge --auto -sd";
          addme = "pr edit --add-assignee @me";
          addrocks = "pr edit --add-reviewer strise/rocks";
        };
      };
    };
  };
}
