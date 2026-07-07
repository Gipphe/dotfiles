{ util, ... }:
util.mkProfile {
  name = "gaming";
  shared.gipphe.gaming = {
    bolt-launcher.enable = true;
    gamemode.enable = true;
    gamescope.enable = true;
    heroic.enable = true;
    limo.enable = true;
    lutris.enable = true;
    mangohud.enable = true;
    prismlauncher.enable = true;
    runelite.enable = true;
    steam.enable = true;
  };
  shared.gipphe.programs = {
    discord.enable = true;
  };
}
