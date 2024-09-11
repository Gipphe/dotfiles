{ util, ... }:
util.mkProgram {
  name = "spotify-player";
  # brew-nix cask hash for spotify: "sha256-JfrxFFYXrFWCqt1fxm79+hqHaiWETeXZ2cQzO59qiv4="
  hm.programs.spotify-player.enable = true;
}
