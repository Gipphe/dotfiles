{ util, ... }:
util.mkProfile {
  name = "gaming";
  shared.gipphe.programs = {
    bolt-launcher.enable = true;
    discord.enable = true;
    gamemode.enable = true;
    heroic.enable = true;
    lutris.enable = true;
    prismlauncher.enable = true;
    runelite.enable = true;
    steam.enable = true;
  };
}
