{
  den.aspects.programs.mpd.homeManager = { user }: {
    services.mpd = {
      enable = true;
      musicDirectory = "${user.homeDirectory}/Music";
    };
  };
}
