{ util, ... }:
util.mkProfile {
  name = "game-dev";
  shared.gipphe.programs = {
    godot.enable = true;
    libresprite.enable = true;
    rider.enable = true;
  };
}
