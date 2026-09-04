{
  config,
  lib,
  inputs,
  util,
  pkgs,
  ...
}:
let
  module = (inputs.wlib.lib.evalModule ./wrapper.nix).config.eval {
    inherit pkgs;
    extensions = [ pkgs.gh-stack ];
    settings = lib.mkMerge [
      {
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
      }
      config.gipphe.programs.gh.settings
    ];
    hosts = {
      "github.com" = {
        git_protocol = "ssh";
        users.Gipphe = { };
        user = "Gipphe";
      };
    };
  };
in
util.mkProgram {
  name = "gh";
  options.gipphe.programs.gh.settings = module.options.settings;
  homeManager = {
    home.packages = [ module.config.wrapper ];
    options.gipphe.programs.gh.package = lib.mkPackageOption pkgs "gh" { } // {
      default = module.config.wrapper;
    };
    gipphe.programs.git = module.config.passthru.git;
    xdg = module.config.passthru.xdg;
  };
}
