{ util, ... }:
util.mkProfile "work" {
  gipphe.programs = {
    cyberduck.enable = true;
    idea-ultimate.enable = true;
    neo4j-desktop.enable = true;
    notion.enable = true;
    openvpn-connect.enable = true;
    slack.enable = true;
  };
}
