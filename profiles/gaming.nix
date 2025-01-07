{ util, ... }:
util.mkProfile "gaming" {
  gipphe.programs = {
    discord.enable = true;
    lutris.enable = true;
    moonlight-qt.enable = true;
    steam.enable = true;
  };
}
