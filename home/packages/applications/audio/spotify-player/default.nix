{ lib, config, ... }:
{
  # brew-nix cask hash for spotify: "sha256-JfrxFFYXrFWCqt1fxm79+hqHaiWETeXZ2cQzO59qiv4="
  options.gipphe.programs.spotify-player.enable = lib.mkEnableOption "spotify-player";
  config = lib.mkIf config.gipphe.programs.spotify-player.enable {
    programs.spotify-player.enable = true;
  };
}
