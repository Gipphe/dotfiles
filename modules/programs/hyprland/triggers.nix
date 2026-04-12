{
  util,
  config,
  lib,
  ...
}:
util.mkModule {
  hm = {
    wayland.windowManager.hyprland.settings =
      let
        inherit (config.gipphe.core.wm) triggers;
        trigger = import ./trigger.nix;
        triggerMapToExecs =
          triggers:
          lib.pipe triggers [
            builtins.attrValues
            (map trigger.toHyprTrigger)
          ];
      in
      {
        exec = triggerMapToExecs triggers.on-load;
        exec-once = triggerMapToExecs triggers.on-startup;
      };
  };
}
