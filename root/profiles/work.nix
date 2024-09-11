{ util, ... }:
util.mkProfile "work" {
  gipphe.programs = {
    cyberduck.enable = true;
    google-cloud-sdk.enable = true;
    idea-ultimate.enable = true;
    kubectl.enable = true;
    kubectx.enable = true;
    neo4j-desktop.enable = true;
    notion.enable = true;
    openvpn-connect.enable = true;
    slack.enable = true;
  };
}
