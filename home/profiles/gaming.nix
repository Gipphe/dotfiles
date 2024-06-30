{ util, ... }:
util.mkProfile "gaming" {
  gipphe.programs = {
    lutris.enable = true;
    discord.enable = true;
  };
}
