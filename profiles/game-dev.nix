{ util, ... }:
util.mkProfile "game-dev" {
  gipphe.programs = {
    libresprite.enable = true;
  };
}
