{
  config,
  inputs,
  util,
  pkgs,
  ...
}:
util.mkProgram {
  name = "gh";
  homeManager = {
    imports = [
      (inputs.wlib.lib.getInstallModule {
        name = "gh";
        value = ./wrapper.nix;
      })
    ];
    wrappers.gh = {
      enable = true;
      extensions = [ pkgs.gh-stack ];
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
        };
      };
      hosts = {
        "github.com" = {
          git_protocol = "ssh";
          users.Gipphe = { };
          user = "Gipphe";
        };
      };
      env.GH_SPINNER_DISABLED = "1";
    };
    wrappers.git = config.wrappers.gh.passthru.git;
    xdg = config.wrappers.gh.passthru.xdg;
  };
}
