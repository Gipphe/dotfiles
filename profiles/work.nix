{ util, ... }:
util.mkProfile "work" {
  gipphe = {
    profiles.work-slim.enable = true;
    programs = {
      cyberduck.enable = true;
      neo4j-desktop.enable = true;
      notion.enable = true;
      openvpn-connect.enable = true;
      slack.enable = true;
    };
  };
}
