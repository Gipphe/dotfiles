{
  util,
  config,
  lib,
  ...
}:
util.mkModule {
  home-manager = {
    wayland.windowManager.hyprland.settings.on =
      let
        inherit (config.gipphe.core.wm) triggers;
        toLua = lib.generators.toLua { };
        triggerToExec = { command }: "hl.exec_cmd(${toLua command})";
        toEvent = event: action: {
          _args = [
            event
            (lib.mkLuaInline ''
              function()
                ${action}
              end
            '')
          ];
        };
        toTriggers =
          event: triggers:
          lib.pipe triggers [
            builtins.attrValues
            (map triggerToExec)
            (builtins.concatStringsSep "\n")
            (toEvent event)
          ];
        startupTriggers = toTriggers "hyprland.start" triggers.on-startup;
        reloadTriggers = toTriggers "config.reloaded" triggers.on-load;
      in
      [
        startupTriggers
        reloadTriggers
      ];
  };
}
