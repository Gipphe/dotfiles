{ util, ... }:
util.mkProfile {
  name = "gaming";
  shared.gipphe.programs = {
    discord.enable = true;
    heroic.enable = true;
    lutris.enable = true;
    moonlight-qt.enable = true;
    steam.enable = true;
  };
}
