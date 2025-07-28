{
  util,
  lib,
  config,
  ...
}:
util.mkProfile "lovdata" {
  gipphe = {
    programs = {
      devbox.enable = true;
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
      glab.enable = true;
      glab.settings.hosts."git.lovdata.no" = {
        git_protocol = "ssh";
        api_protocol = "https";
        user = "vnb";
        token_path = "${config.gipphe.homeDirectory}/.config/sops-nix/secrets/lovdata-gitlab-ci-access-token";
      };
      glab.aliases =
        let
          team_members = {
            audun = "agevelt";
            stian = "stian";
          };
        in
        lib.mapAttrs (name: handle: "mr update --reviewer '${handle}'") team_members;
    };
    virtualisation = {
      docker.enable = true;
    };
    lovdata.files.enable = true;
    networking.lovdata-dns.enable = true;
  };
}
