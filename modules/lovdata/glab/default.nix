{
  util,
  pkgs,
  config,
  ...
}:
util.mkToggledModule [ "lovdata" ] {
  name = "glab";
  hm = {
    sops.secrets.lovdata-gitlab-ci-access-token = {
      format = "binary";
      sopsFile = ../../../secrets/utv-vnb-lt-gitlab-cli-access-token.txt;
    };
    home.packages = [
      (pkgs.writeShellScriptBin "glabl" ''
        export GITLAB_TOKEN="$(cat '${config.sops.secrets.lovdata-gitlab-ci-access-token.path}')"
        export GITLAB_HOST="https://git.lovdata.no"
        export GITLAB_GROUP="ld"
        ${config.gipphe.programs.glab.package}/bin/glab "$@"
      '')
    ];
  };
}
