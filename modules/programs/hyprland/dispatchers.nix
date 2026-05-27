{ lib }:
let
  lit = lib.mkLuaInline;
  toLua = lib.generators.toLua { };
  one_arg = [
    "exec_cmd"
    "exec_raw"
    "focus"
    "submap"
    "pass"
    "send_shortcut"
    "send_key_state"
    "layout"
    "dpms"
    "event"
    "global"
    "force_idle"
  ];
  no_args = [
    "exit"
    "no_op"
  ];
in
lib.genAttrs one_arg (fn: args: lit "hl.dsp.${fn}(${toLua args})")
// lib.genAttrs no_args (fn: lit "hl.dsp.${fn}()")
// {
  exec_cmdr = cmd: rules: lit "hl.dsp.exec_cmd(${toLua cmd}, ${toLua rules})";

  window =
    let
      one_arg = [
        "close"
        "kill"
        "signal"
        "float"
        "fullscreen"
        "fullscreen_state"
        "pseudo"
        "move"
        "swap"
        "center"
        "cycle_next"
        "tag"
        "pin"
        "alter_zorder"
        "set_prop"
        "deny_from_group"
      ];
      no_args = [
        "toggle_swallow"
        "drag"
        "resize"
      ];
    in
    lib.genAttrs one_arg (fn: args: lit "hl.dsp.window.${fn}(${toLua args})")
    // lib.genAttrs no_args (fn: lit "hl.dsp.window.${fn}()")
    // {
      resizexy = args: lit "hl.dsp.window.resize(${toLua args})";
    };

  workspace =
    let
      one_arg = [
        "rename"
        "move"
        "swap_monitors"
        "toggle_special"
      ];
    in
    lib.genAttrs one_arg (fn: args: lit "hl.dsp.workspace.${fn}(${toLua args})");

  group =
    let
      one_arg = [
        "toggle"
        "next"
        "prev"
        "active"
        "move_window"
        "lock"
        "lock_active"
      ];
    in
    lib.genAttrs one_arg (fn: args: lit "hl.dsp.group.${fn}(${toLua args})");

  cursor =
    let
      one_arg = [
        "move_to_corner"
        "move"
      ];
    in
    lib.genAttrs one_arg (fn: args: lit "hl.dsp.cursor.${fn}(${toLua args})");
}
