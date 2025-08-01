{ util, ... }:
util.mkProfile {
  name = "strise";
  shared.gipphe = {
    profiles.strise-slim.enable = true;
    programs = {
      code-cursor.enable = true;
      cyberduck.enable = true;
      neo4j-desktop.enable = true;
      notion.enable = true;
      openvpn-connect.enable = true;
      slack.enable = true;
    };
  };
}
