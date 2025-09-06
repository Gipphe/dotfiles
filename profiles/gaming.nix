{ util, ... }:
util.mkProfile {
  name = "gaming";
  shared.gipphe.programs = {
    bolt-launcher.enable = true;
    discord.enable = true;
    gdlauncher.enable = true;
    heroic.enable = true;
    lutris.enable = true;
    moonlight-qt.enable = true;
    runelite.enable = true;
    steam.enable = true;
  };
}
