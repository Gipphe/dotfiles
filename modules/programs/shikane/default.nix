{ util, ... }:
util.mkProgram {
  name = "shikane";
  homeManager.services.shikane = {
    enable = true;
    settings = {
      profile = [ ];
    };
  };
}
