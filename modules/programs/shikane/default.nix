{ util, ... }:
util.mkProgram {
  name = "shikane";
  home-manager.services.shikane = {
    enable = true;
    settings = {
      profile = [ ];
    };
  };
}
