{
  util,
  lib,
  config,
  ...
}:
let
  cfg = config.gipphe.programs.hyprland;
in
util.mkModule {
  shared.imports = [
    ./animations.nix
    ./binds.nix
    ./config.nix
    ./devices.nix
    ./events.nix
    ./env.nix
    ./gestures.nix
    ./monitors.nix
    ./permissions.nix
    ./windowRules.nix
    ./workspaceRules.nix
  ];
  options.gipphe.programs.hyprland = {
    settings.rendered = lib.mkOption {
      type = lib.types.lines;
      description = "The rendered hyprland lua config";
      default = "";
      internal = true;
    };
  };
  hm = {
    xdg.configFile = {
      "hypr/hyprland.lua".text = cfg.settings.rendered;
      "hypr/hyprland.conf".enable = false;
    };
  };
}
