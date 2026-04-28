{
  lib,
  util,
  config,
  ...
}:
let
  cfg = config.gipphe.programs.hyprland;
  toLua = lib.generators.toLua { };
  toOn = on: /* lua */ ''
    hl.on(${toLua on.event}, function(...)
      (${on.action})(...)
    end)
  '';
in
util.mkModule {
  options.gipphe.programs.hyprland.settings = {
    on = lib.mkOption {
      description = "Event listeners";
      default = [ ];
      example = lib.literalExpression ''
        [
          {
            event = "window.destroy";
            action = '''
              function(ws)
                hl.dsp.exec_cmd("echo foo")
              end
            ''';
          }
        ]
      '';
      type =
        with lib.types;
        listOf (submodule {
          options = {
            event = lib.mkOption {
              description = ''
                The event to bind this action to.

                - `hyprland.start`: Emitted once on start. Args: None
                - `hyprland.shutdown`: Emitted once before Hyprland exiting. Args: None
                - `window.open`: Emitted when a window is fully initialized with window rules applied. Args: Window
                - `window.open_early`: Emitted when a window is created and mapped, but before window rules are applied. Args: Window
                - `window.close`: Emitted when a window is closed. It may still be visible during its closing animation. Args: Window
                - `window.destroy`: Emitted when a window is removed from the compositor. For windows with a close animation, fires after the animation completes. Args: Window
                - `window.kill`: Emitted when a window is forcefully killed via hyprctl kill. Args: Window
                - `window.active`: Emitted when the active window changes. Args: Window, int [0/1]
                - `window.urgent`: Emitted when a window requests an urgent state. Args: Window
                - `window.title`: Emitted when a window title changes. Args: Window
                - `window.class`: Emitted when a window class changes. Args: Window
                - `window.pin`: Emitted when a window is pinned or unpinned. Args: Window
                - `window.fullscreen`: Emitted when the fullscreen status of a window changes. Args: Window
                - `window.update_rules`: Emitted when a window’s rules are re-evaluated, e.g. when its title or class changes. Args: Window
                - `window.move_to_workspace`: Emitted when a window is moved to a different workspace. Args: Window, Workspace
                - `layer.opened`: Emitted when a layer surface is opened. Args: LayerSurface
                - `layer.closed`: Emitted when a layer surface is closed. Args: LayerSurface
                - `monitor.added`: Emitted when a monitor is connected and ready. Args: Monitor
                - `monitor.removed`: Emitted when a monitor is disconnected and removed. Args: Monitor
                - `monitor.focused`: Emitted when the active monitor changes. Args: Monitor
                - `monitor.layout_changed`: Emitted when the monitor arrangement changes. This occurs when a monitor is added or removed, a monitor’s resolution or refresh rate is changed, or the config is reloaded with different rules. Args: None
                - `workspace.active`: Emitted when the active workspace on a monitor changes. Args: Workspace
                - `workspace.created`: Emitted when a workspace is created. Args: Workspace
                - `workspace.removed`: Emitted when a workspace is removed. Args: Workspace
                - `workspace.move_to_monitor`: Emitted when a workspace is moved to a different monitor. Args: Workspace, Monitor
                - `config.reloaded`: Emitted when the config has been reloaded and applied. Args: None
                - `keybinds.submap: Emitted when the active submap changes. An empty string means the default submap was restored. Args: String`: Submap Name
                - `screenshare.state: Emitted when a screenshare session starts or stops. Args: Bool: Active, Integer: Type, String`: Name
              '';
              type = enum [
                "hyprland.start"
                "hyprland.shutdown"
                "window.open"
                "window.open_early"
                "window.close"
                "window.destroy"
                "window.kill"
                "window.active"
                "window.urgent"
                "window.title"
                "window.class"
                "window.pin"
                "window.fullscreen"
                "window.update_rules"
                "window.move_to_workspace"
                "layer.opened"
                "layer.closed"
                "monitor.added"
                "monitor.removed"
                "monitor.focused"
                "monitor.layout_changed"
                "workspace.active"
                "workspace.created"
                "workspace.removed"
                "workspace.move_to_monitor"
                "config.reloaded"
                "keybinds.submap"
                "screenshare.state"
              ];
              example = "hyprland.start";
            };

            action = lib.mkOption {
              description = "Inline Lua function definition to execute on said event.";
              type = lines;
              example = ''
                function(ws)
                  hl.dsp.exec_cmd("foo")
                end
              '';
            };
          };
        });
    };

    exec = {
      onStartup = lib.mkOption {
        type = with lib.types; listOf str;
        default = [ ];
        description = "Commands to execute on Hyprland start";
      };
      onReload = lib.mkOption {
        type = with lib.types; listOf str;
        default = [ ];
        description = "Commands to execute on config reload";
      };
    };
  };
  hm = {
    gipphe.programs.hyprland.settings = {
      rendered = lib.mkIf (cfg.settings.on != [ ]) ''
        ${builtins.concatStringsSep "\n" (map toOn cfg.settings.on)}
      '';
      on =
        let
          toCommand = event: cmd: {
            inherit event;
            action = ''
              function()
                hl.dsp.exec_cmd(${toLua cmd})
              end
            '';
          };
          startupCommands = map (toCommand "hyprland.start") cfg.settings.exec.onStartup;
          reloadCommands = map (toCommand "config.reloaded") cfg.settings.exec.onReload;
        in
        startupCommands ++ reloadCommands;
    };
  };
}
