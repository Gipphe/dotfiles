{ lib, config, ... }:
{
  options.gipphe.profiles.desktop.work.enable = lib.mkEnableOption "desktop.work profile";
  config = lib.mkIf config.gipphe.profiles.desktop.work.enable {
    gipphe.programs = {
      idea-ultimate.enable = true;
      neo4j-desktop.enable = true;
      notion.enable = true;
      slack.enable = true;
      openvpn-connect.enable = true;
    };
  };
}
