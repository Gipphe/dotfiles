{ util, ... }:
util.mkProfile "lovdata" {
  gipphe.programs = {
    mattermost.enable = true;
  };
}
