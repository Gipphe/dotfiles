{ util, ... }:
util.mkProfile "game-dev" {
  gipphe.programs = {
    godot.enable = true;
    libresprite.enable = true;
  };
}
