{ lib, config, ... }:
{
  options.gipphe.profiles.work.enable = lib.mkEnableOption "work profile";
  config = lib.mkIf config.gipphe.profiles.work.enable {
    gipphe.programs = {
      idea-ultimate.enable = true;
      neo4j-desktop.enable = true;
      notion.enable = true;
      slack.enable = true;
      openvpn-connect.enable = true;
    };
  };
}
