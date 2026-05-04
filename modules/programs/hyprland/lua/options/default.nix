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
    settings.extra = {
      pre = lib.mkOption {
        type = lib.types.lines;
        description = ''
          Extra literal Lua configuration to prepend to the beginning of the
          rendered Lua config.
        '';
        default = "";
        example = /* lua */ ''
          hl.dsp.exec_cmd("echo begin")
        '';
      };
      post = lib.mkOption {

        type = lib.types.lines;
        description = ''
          Extra literal Lua configuration to append to the end of the rendered
          Lua config.
        '';
        default = "";
        example = /* lua */ ''
          hl.dsp.exec_cmd("echo end")
        '';
      };
    };
  };
  hm = {
    xdg.configFile = {
      "hypr/hyprland.lua".text = ''
        ${cfg.settings.extra.pre}
        ${cfg.settings.rendered}
        ${cfg.settings.extra.post}
      '';
      "hypr/hyprland.conf".enable = false;
    };
  };
}
