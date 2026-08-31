{
  config,
  lib,
  util,
  ...
}:
let
  inherit (builtins)
    concatStringsSep
    isString
    attrNames
    ;
  toDispatch =
    action:
    if isString action.spawn then
      { action.dispatch.exec_cmd = [ action.spawn ]; }
    else if isString action.shortcut then
      { action.dispatch.global = [ action.shortcut ]; }
    else
      abort "Unknown keybind action: ${concatStringsSep ", " (attrNames action)}";
  mkFlags =
    coreBind:
    if coreBind.args ? allow-when-locked && coreBind.args.allow-when-locked then
      { locked = true; }
    else
      { };

  toNiceHyprBindConfig = lib.mapAttrs (
    _: value:
    let
      opts = mkFlags value;
    in
    toDispatch value.action // lib.optionalAttrs (opts != { }) { inherit opts; }
  );
in
util.mkModule {
  shared.gipphe.programs.hyprland.settings.bind = toNiceHyprBindConfig config.gipphe.core.wm.bind;
}
