{ util, ... }:
util.mkProfile "lovdata" {
  gipphe.programs = {
    idea-ultimate.enable = true;
    mattermost.enable = true;
    openconnect.enable = true;
    ssh = {
      enable = true;
      lovdata.enable = true;
    };
  };
}
