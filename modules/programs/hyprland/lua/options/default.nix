{
  pkgs,
  util,
  lib,
  config,
  ...
}:
let
  cfg = config.gipphe.programs.hyprland;

  hmCfg = config.wayland.windowManager.hyprland;
  variables = builtins.concatStringsSep " " hmCfg.systemd.variables;
  extraCommands = builtins.concatStringsSep " " (map (f: "&& ${f}") hmCfg.systemd.extraCommands);
  systemdActivation = ''
    hl.on('hyprland.start', function()
      hl.exec_cmd('${pkgs.dbus}/bin/dbus-update-activation-environment --systemd ${variables} ${extraCommands}')
    end)
  '';
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
      "hypr/hyprland.lua".text =
        lib.optionalString (hmCfg.systemd.enable) systemdActivation
        + lib.optionalString (cfg.settings.extra.pre != "") cfg.settings.extra.pre
        + lib.optionalString (cfg.settings.rendered != "") cfg.settings.rendered
        + lib.optionalString (cfg.settings.extra.post != "") cfg.settings.extra.post;
      "hypr/hyprland.conf".enable = false;
    };
  };
}
