{ den, ... }: {
  den.aspects.programs.discord = {
    includes = [
      (den.batteries.unfree [
        "discord"
        "discord-unwrapped"
      ])
    ];
    homeManager.programs.discord.enable = true;
  };
}
