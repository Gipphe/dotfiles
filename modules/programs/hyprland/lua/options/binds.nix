{
  config,
  util,
  lib,
  ...
}:
let
  inherit (import ./utils.nix) removeNullAttrs;
  cfg = config.gipphe.programs.hyprland;
  toLua = lib.generators.toLua { };
  toLua' = lib.generators.toLua;
  indentLines =
    indent: ss:
    lib.pipe ss [
      (lib.splitString "\n")
      (map (s: "${indent}${s}"))
      lib.concatLines
    ];
  toInnerBind =
    indent: binding:
    let
      flags = removeNullAttrs (
        removeAttrs binding [
          "key"
          "dispatcher"
        ]
      );
      flagsArg = if flags != { } then ", ${toLua' { inherit indent; } flags}" else "";
    in
    "hl.bind(${toLua binding.key}, ${toLua binding.dispatcher}${flagsArg})";
  toBind = toInnerBind "";

  toInnerSubmap =
    indent: submapName: submap:
    let
      nextMap =
        if submap ? next && submap.next != "" && submap.next != null then "${toLua submap.next}, " else "";
    in
    # lua
    indentLines indent ''
      hl.define_submap(${toLua submapName}, ${nextMap}function()
        ${builtins.concatStringsSep "\n" (map (toInnerBind "${indent}  ") submap.binds)}
        ${builtins.concatStringsSep "\n" (
          lib.mapAttrsToList (toInnerSubmap "${indent}  ") submap.submaps
        )}
      end)
    '';
  toSubmap = toInnerSubmap "";

  flagOpt =
    description:
    lib.mkOption {
      inherit description;
      type = with lib.types; nullOr bool;
      default = null;
    };
  bindValue =
    with lib.types;
    submodule {
      options = {
        key = lib.mkOption {
          type = str;
          description = "Key to trigger the bind.";
          example = lib.literalExpression /* nix */ ''
            "''${mod} + ALT + B"
          '';
        };
        dispatcher = lib.mkOption {
          type = luaInline;
          description = "Dispatcher to use for the bind.";
          example = lib.literalExpression /* nix */ ''
            lib.mkLuaInline "hl.dsp.exec_cmd('echo foo')"
          '';
        };
        mouse = flagOpt ''
          Bind relies in mouse movement. Common mouse button key codes:
          - LMB: 272
          - RMB: 273
          - MMB: 274

          See the dedicated [Mouse Binds](https://wiki.hypr.land/Configuring/Basics/Binds/#mouse-binds) section.
        '';
        locked = flagOpt "Will also work when an input inhibitor (e.g. a lockscreen) is active.";
        release = flagOpt "Will trigger on release of a key.";
        click = flagOpt "Will trigger on release of a key or button as long as the mouse cursor stays inside `binds:drag_threshold`.";
        drag = flagOpt "Will trigger on release of a key or button as long as the mouse cursor moves outside `binds:drag_threshold`.";
        long_press = flagOpt "Will trigger on long press of a key.";
        repeating = flagOpt "Will repeat when held.";
        non_consuming = flagOpt "Key/mouse events will be passed to the active window in addition to triggering the dispatcher.";
        transparent = flagOpt "Cannot be shadowed by other binds.";
        ignore_mods = flagOpt "Will ignore modifiers.";
        separate = flagOpt "Will arbitrarily combine keys between each mod/key, see [Keysym combos](https://wiki.hypr.land/Configuring/Basics/Binds/#keysym-combos)";
        description = flagOpt "Will allow you to write a description for your bind.";
        bypass = flagOpt "Bypasses the app’s requests to inhibit keybinds.";
        submap_universal = flagOpt "Will be active no matter the submap.";
        devices = flagOpt "Allow binds to be set per device. See [Per-Device Binds](https://wiki.hypr.land/Configuring/Basics/Binds/#per-device-binds).";
      };
    };

  submapType =
    with lib.types;
    attrsWith {
      placeholder = "submap-name";
      elemType = submodule {
        options = {
          next = lib.mkOption {
            description = ''
              Submap to activate after pressing a key in this submap. Set
              this to `"reset"` to automatically exit the submap once a key
              is pressed.
            '';
            type = nullOr str;
            default = null;
            example = "reset";
          };
          binds = lib.mkOption {
            description = "Bindings for this submap";
            type = listOf bindValue;
            default = [ ];
            example = lib.literalExpression /* nix */ ''
              [
                {
                  key = "ALT + L";
                  dispatcher = lib.mkLuaInline "hl.dsp.exec_cmd('hyprlock')";
                }
              ]
            '';
          };
          submaps = lib.mkOption {
            description = "Nested submaps";
            type = submapType;
            default = { };
            example = lib.literalExpression /* nix */ ''
                {
                  nested-submap = {
                    binds = [
                      {
                        key = "ALT + X";
                        dispatcher = lib.mkLuaInline "hl.dsp.exec_cmd('echo foo')";
                      }
                      {
                        key = "escape";
                        dispatcher = lib.mkLuaInline "hl.submap('parent-submap')";
                      }
                    ];
                  };
                }
              ]
            '';
          };
        };
      };
    };
in
util.mkModule {
  options.gipphe.programs.hyprland.settings = {
    binds = lib.mkOption {
      type = lib.types.listOf bindValue;
      default = [ ];
      example = lib.literalExpression /* nix */ ''
        let
          mod = "SUPER";
        in
        [
          # mouse movements
          {
            key = "''${mod} + mouse:272";
            dispatcher = lib.mkLuaInline "hl.dsp.window.drag()";
            mouse = true;
          }
          {
            key = "''${mod} + mouse:273";
            dispatcher = lib.mkLuaInline "hl.dsp.window.resize()";
            mouse = true;
          }
          {
            key = "''${mod} + ALT + mouse:272";
            dispatcher = lib.mkLuaInline "hl.dsp.window.resize()";
            mouse = true;
          }
        ];
      '';
    };
    submaps = lib.mkOption {
      description = ''
        Submaps for key bindings. Activate a submap using the
        `hl.dsp.submap("submapname")` dispatcher. And don't forget to include a
        binding for `hl.dsp.submap("reset")` in your submap to escape the
        submap.
      '';
      default = { };
      example = lib.literalExpression /* nix */ ''
        {
          resize = {
            binds = [
              {
                key = "right";
                dispatcher = lib.mkLuaInline "hl.resize({x = 10, y = 0, relative = true})";
                repeating = true;
              }
              {
                key = "left";
                dispatcher = lib.mkLuaInline "hl.resize({x = -10, y = 0, relative = true})";
                repeating = true;
              }
              {
                key = "up";
                dispatcher = lib.mkLuaInline "hl.resize({x = 0, y = 10, relative = true})";
                repeating = true;
              }
              {
                key = "down";
                dispatcher = lib.mkLuaInline "hl.resize({x = 0, y = -10, relative = true})";
                repeating = true;
              }
            ];
          };
        }
      '';
      type = submapType;
    };
  };
  hm = {
    gipphe.programs.hyprland.settings.rendered =
      lib.optionalString (cfg.settings.binds != [ ]) (
        lib.concatStringsSep "\n" (map toBind cfg.settings.binds)
      )
      + "\n"
      + lib.optionalString (cfg.settings.submaps != [ ]) (
        lib.concatStringsSep "\n" (lib.mapAttrsToList toSubmap cfg.settings.submaps)
      );
  };
}
