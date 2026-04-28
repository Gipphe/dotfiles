{
  lib,
  config,
  util,
  ...
}:
let
  inherit (import ./utils.nix) removeNullAttrs;
  cfg = config.gipphe.programs.hyprland;
  toLua = lib.generators.toLua { };
  toGesture =
    gesture:
    let
      renderedGesture =
        if builtins.isString gesture.action || (gesture.action._type or null) == "lua-inline" then
          gesture
        else
          removeNullAttrs (gesture // gesture.action);
    in
    /* lua */ ''
      hl.gesture(${toLua renderedGesture})
    '';
in
util.mkModule {
  options.gipphe.programs.hyprland.settings.gestures = lib.mkOption {
    description = "Gesture definitions";
    default = [ ];
    example = lib.literalExpression /* nix */ ''
      [
        {
          fingers = 3;
          direction = "horizontal";
          action = "workspace";
        }
        {
          fingers = 3;
          direction = "pinch";
          action = lib.mkLuaInline '''
            function()
              hl.exec_cmd('kitty')
            end
          ''';
        }
      ]
    '';
    type =
      with lib.types;
      listOf (submodule {
        options = {
          fingers = lib.mkOption {
            description = "Number of fingers to activate gesture";
            type = ints.between 2 9;
            example = 3;
          };
          direction = lib.mkOption {
            description = ''
              Gesture direction. See
              [directions](https://wiki.hypr.land/Configuring/Advanced-and-Cool/Gestures/#directions)
              for descriptions of each of the options.
            '';
            type = enum [
              "swipe"
              "horizontal"
              "vertical"
              "left"
              "right"
              "up"
              "down"
              "pinch"
              "pinchin"
              "pinchout"
            ];
            example = "horizontal";
          };
          action = lib.mkOption {
            description = "Action to perform. See [actions](https://wiki.hypr.land/Configuring/Advanced-and-Cool/Gestures/#actions) for a description of each alternative.";
            example = "workspace";
            type = oneOf [
              luaInline
              (submodule {
                options = {
                  action = lib.mkOption {
                    description = "Action to perform";
                    type = lit "special";
                    example = "special";
                  };
                  workspace_name = lib.mkOption {
                    description = "Name of the special workspace to toggle";
                    type = str;
                    example = "my-workspace";
                  };
                };
              })
              (submodule {
                options.action = lib.mkOption {
                  description = "Action to perform";
                  type = lit "fullscreen";
                  example = "fullscreen";
                };
                options.mode = lib.mkOption {
                  description = "Set to 'maximize' to maxmize instead of full screen";
                  type = nullOr (lit "maximize");
                  default = null;
                  example = "maximize";
                };
              })
              (submodule {
                options.action = lib.mkOption {
                  description = "Action to perform";
                  type = lit "float";
                  example = "float";
                };
                options.mode = lib.mkOption {
                  description = "'float' or 'tile' to force a direction of floating";
                  type = nullOr (enum [
                    "float"
                    "tile"
                  ]);
                  default = null;
                  example = "float";
                };
              })
              (submodule {
                options.action = lib.mkOption {
                  description = "Action to perform";
                  type = lit "cursorZoom";
                  example = "cursorZoom";
                };
                options.zoom_level = lib.mkOption {
                  description = "Zoom factor";
                  type = float;
                  example = 2.0;
                };
                options.mode = lib.mkOption {
                  description = "Use a multiplier instead of a toggle";
                  type = nullOr (lit "mult");
                  default = null;
                  example = "mult";
                };
              })
              (enum [
                "workspace"
                "move"
                "resize"
                "close"
              ])
            ];
          };
          mods = lib.mkOption {
            description = "Optional modifier mask";
            example = "SUPER";
            type = nullOr str;
            default = null;
          };
          scale = lib.mkOption {
            description = "Optional animation speed multiplier";
            example = 1.1;
            type = nullOr float;
            default = null;
          };
          disable_inhibit = lib.mkOption {
            description = "If true, allows the gesture to bypass shortcut inhibitors";
            example = true;
            type = bool;
            default = false;
          };
        };
      });
  };
  hm = {
    gipphe.programs.hyprland.settings.rendered = ''
      ${builtins.concatStringsSep "\n" (map toGesture cfg.settings.gestures)}
    '';
  };
}
