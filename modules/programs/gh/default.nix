{ inputs, ... }:
{
  den.aspects.programs.gh.homeManager =
    { host }:
    {
      lib,
      config,
      pkgs,
      ...
    }:
    let
      module = (inputs.wrappers.lib.evalModule ./_wrapper.nix).config.eval {
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
    {
      options.gipphe.programs.gh = {
        package = lib.mkPackageOption pkgs "gh" { } // {
          default = module.config.wrapper;
        };
        settings = module.options.settings;
      };
      config = {
        home.packages = [ module.config.wrapper ];
        gipphe.programs.git = module.config.passthru.git;
        xdg = module.config.passthru.xdg;
        programs.nushell.extraConfig = /* nu */ ''
          $env.GH_TOKEN = open --raw '${
            config.sensitive.secrets.secrets."${host.hostName}/gh-token.txt"
          }' | str trim
        '';
      };
    };
}
