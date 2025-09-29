{
  util,
  lib,
  config,
  ...
}:
util.mkProfile {
  name = "lovdata";
  shared = {
    gipphe = {
      programs = {
        idea-ultimate.enable = true;
        ssh.enable = true;
        glab = {
          enable = true;
          settings.hosts."git.lovdata.no" = {
            git_protocol = "ssh";
            api_protocol = "https";
            user = "vnb";
            token_path = "${config.gipphe.homeDirectory}/.config/sops-nix/secrets/lovdata-gitlab-ci-access-token";
          };
          aliases =
            let
              team_members = {
                andre = "amb";
                audun = "agevelt";
                christian = "cekrem";
                simon = "sis";
                stian = "stian";
              };
            in
            lib.mapAttrs' (name: handle: {
              name = "add_${name}";
              value = "mr update --reviewer '${handle}'";
            }) team_members
            // {
              add_team = "mr update --reviewer '${lib.concatStringsSep "," (builtins.attrValues team_members)}'";
            };
        };
      };
      lovdata = {
        cli.enable = true;
        dns.enable = true;
        git.enable = true;
        glab.enable = true;
        java_21.enable = true;
        mattermost.enable = true;
        maven.enable = true;
        memcached.enable = true;
        mounts.enable = true;
        sentinelone.enable = true;
        ssh.enable = true;
        vpn.enable = true;
      };
    };
  };
}
