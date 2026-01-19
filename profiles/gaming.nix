{ util, ... }:
util.mkProfile {
  name = "gaming";
  shared.gipphe.programs = {
    bolt-launcher.enable = true;
    discord.enable = true;
    heroic.enable = true;
    # TODO: Broken dependency
    lutris.enable = false;
    moonlight-qt.enable = true;
    prismlauncher.enable = true;
    runelite.enable = true;
    steam.enable = true;
  };
}
