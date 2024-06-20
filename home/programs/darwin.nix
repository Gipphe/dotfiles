{
  lib,
  config,
  flags,
  inputs,
  pkgs,
  ...
}:
let
  setHash =
    cask: hash:
    cask.overrideAttrs (c: {
      src = cask.src.overrideAttrs { outputHash = hash; };
    });
  _brewPkgs = inputs.brew-nix.packages.${pkgs.system};
  brewPkgs =
    _brewPkgs
    // (with _brewPkgs; {
      _1password = _brewPkgs."1password";
      filen = setHash filen "sha256-ewoPrA8HuYftz9tvp7OUgDqikKhPZ7WOVyWH83oADJQ=";
      logi-options-plus = setHash logi-options-plus "sha256-pFIwl229bSEJmcbRj0ktbPSr9SR31LakPLDWDclPQW4=";
      spotify = setHash spotify "sha256-JfrxFFYXrFWCqt1fxm79+hqHaiWETeXZ2cQzO59qiv4=";
      xnviewmp = setHash xnviewmp "sha256-TE87nserf+7TJRfuD1pKdEBg9QHNxyet06jrGlGRPGc=";
    });
in
lib.optionalAttrs flags.system.isNixDarwin {
  options.programs = {
    # Handled in NixOS config
    _1password.enable = lib.mkEnableOption "_1password";
    karabiner-elements.enable = lib.mkEnableOption "karabiner-elements";
    logi-options-plus.enable = lib.mkEnableOption "logi-options-plus";
    openvpn-connect.enable = lib.mkEnableOption "openvpn-connect";

    # Handled through brew-nix
    alt-tab.enable = lib.mkEnableOption "alt-tab";
    barrier.enable = lib.mkEnableOption "barrier";
    cyberduck.enable = lib.mkEnableOption "cyberduck";
    filen.enable = lib.mkEnableOption "filen";
    gimp.enable = lib.mkEnableOption "gimp";
    linearmouse.enable = lib.mkEnableOption "linearmouse";
    neo4j.enable = lib.mkEnableOption "neo4j";
    notion.enable = lib.mkEnableOption "notion";
    obsidian.enable = lib.mkEnableOption "obsidian";
    slack.enable = lib.mkEnableOption "slack";
    spotify.enable = lib.mkEnableOption "spotify";
    xnviewmp.enable = lib.mkEnableOption "xnviewmp";
  };
  options.virtualisation.docker.enable = lib.mkEnableOption "docker";
  config = {
    home.packages =
      with brewPkgs;
      lib.flatten [
        (lib.optional config.programs.alt-tab.enable alt-tab)
        (lib.optional config.programs.barrier.enable barrier)
        (lib.optional config.programs.cyberduck.enable cyberduck)
        (lib.optional config.programs.filen.enable filen)
        (lib.optional config.programs.gimp.enable gimp)
        (lib.optional config.programs.linearmouse.enable linearmouse)
        (lib.optional config.programs.neo4j.enable neo4j)
        (lib.optional config.programs.notion.enable notion)
        (lib.optional config.programs.obsidian.enable obsidian)
        (lib.optional config.programs.slack.enable slack)
        (lib.optional config.programs.spotify.enable spotify)
        (lib.optional config.programs.xnviewmp.enable xnviewmp)
      ];
  };
}
