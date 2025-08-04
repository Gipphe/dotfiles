{ util, ... }:
util.mkProgram {
  name = "shikane";
  hm.services.shikane = {
    enable = true;
    settings = {
      profile = [ ];
    };
  };
}
