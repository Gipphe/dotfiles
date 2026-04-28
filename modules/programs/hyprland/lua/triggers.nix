{
  util,
  config,
  lib,
  ...
}:
util.mkModule {
  hm = {
    gipphe.programs.hyprland.settings.on =
      let
        dispatch = import ./options/dispatchers.nix { inherit lib; };
        inherit (config.gipphe.core.wm) triggers;
        triggerToDispatcher = { command }: dispatch.exec_cmd command;
        toEvent = event: action: {
          inherit event;
          action = ''
            function()
              ${action}
            end
          '';
        };
        toTriggers =
          event: triggers:
          lib.pipe triggers [
            builtins.attrValues
            (map triggerToDispatcher)
            (map (x: x.expr))
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
