{
  util,
  lib,
  config,
  ...
}:
util.mkProfile {
  name = "lovdata";
  shared.gipphe = {
    programs = {
      devbox.enable = true;
      docker.enable = true;
      idea-ultimate.enable = true;
      java_21.enable = true;
      mattermost.enable = true;
      maven.enable = true;
      memcached.enable = true;
      openconnect.enable = true;
      sentinelagent.enable = true;
      ssh = {
        enable = true;
        lovdata.enable = true;
      };
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
              audun = "agevelt";
              stian = "stian";
              simon = "sis";
              christian = "cekrem";
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
    lovdata.files.enable = true;
    networking.lovdata-dns.enable = true;
  };
}
