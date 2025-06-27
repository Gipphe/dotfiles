{ util, ... }:
util.mkProfile "lovdata" {
  gipphe = {
    programs = {
      idea-ultimate.enable = true;
      java_21.enable = true;
      mattermost.enable = true;
      maven.enable = true;
      memcached.enable = true;
      openconnect.enable = true;
      ssh = {
        enable = true;
        lovdata.enable = true;
      };
    };
    virtualisation = {
      docker.enable = true;
    };
    networking.lovdata-dns.enable = true;
  };
}
