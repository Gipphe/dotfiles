{
  config,
  lib,
  util,
  ...
}:
let
  inherit (import ./utils.nix) removeNullAttrsRecursive;
  cfg = config.gipphe.programs.hyprland;
  toLua = lib.generators.toLua { };
  toWindowRule = rule: "hl.window_rule(${toLua (removeNullAttrsRecursive rule)})";
  toLayerRule = rule: "hl.layer_rule(${toLua (removeNullAttrsRecursive rule)})";
in
util.mkModule {
  options.gipphe.programs.hyprland.settings = {
    windowRules = lib.mkOption {
      description = ''
        Rule for how windows should be positioned and how they behave. Order
        matters!
      '';
      default = [ ];
      example = [
        {
          name = "foo";
          match.class = "my-window";
          border_size = 10;
        }
      ];
      type =
        with lib.types;
        listOf (submodule {
          options = {
            name = lib.mkOption {
              type = nullOr str;
              description = "Descriptive name for the window rule";
              default = null;
              example = "my-rule";
            };
            match = lib.mkOption {
              description = ''
                Matchers to use for selecting windows to apply the rule to. All
                of these have to match for a window to be selected.
              '';
              type =
                with lib.types;
                submodule {
                  options = {
                    class = lib.mkOption {
                      type = nullOr str;
                      default = null;
                      description = "Windows with class matching RegEx.";
                      example = "my-class";
                    };
                    title = lib.mkOption {
                      type = nullOr str;
                      default = null;
                      description = "Windows with title matching RegEx.";
                      example = "my-title";
                    };
                    initial_class = lib.mkOption {
                      type = nullOr str;
                      default = null;
                      description = "Windows with initialClass matching RegEx.";
                      example = "my-initial-class";
                    };
                    initial_title = lib.mkOption {
                      type = nullOr str;
                      default = null;
                      description = "Windows with initialTitle matching RegEx.";
                      example = "my-initial-title";
                    };
                    tag = lib.mkOption {
                      type = nullOr str;
                      default = null;
                      description = "Windows with matching tag.";
                      example = "my-tag";
                    };
                    xwayland = lib.mkOption {
                      type = nullOr bool;
                      default = null;
                      description = "Xwayland windows.";
                      example = true;
                    };
                    float = lib.mkOption {
                      type = nullOr bool;
                      default = null;
                      description = "Floating windows.";
                      example = true;
                    };
                    fullscreen = lib.mkOption {
                      type = nullOr bool;
                      default = null;
                      description = "Fullscreen windows.";
                      example = true;
                    };
                    pin = lib.mkOption {
                      type = nullOr bool;
                      default = null;
                      description = "Pinned windows.";
                      example = true;
                    };
                    focus = lib.mkOption {
                      type = nullOr bool;
                      default = null;
                      description = "Currently focused window.";
                      example = true;
                    };
                    group = lib.mkOption {
                      type = nullOr bool;
                      default = null;
                      description = "Grouped windows.";
                      example = true;
                    };
                    modal = lib.mkOption {
                      type = nullOr bool;
                      default = null;
                      description = "Modal windows (e.g. “Are you sure” popups)";
                      example = true;
                    };
                    fullscreen_state_client = lib.mkOption {
                      type = nullOr (ints.between 0 3);
                      default = null;
                      description = ''
                        Windows with matching fullscreenstate. `0` - none, `1` -
                        maximize, `2` - fullscreen, `3` - maximize and fullscreen.
                      '';
                      example = 1;
                    };
                    fullscreen_state_internal = lib.mkOption {
                      type = nullOr (ints.between 0 3);
                      default = null;
                      description = ''
                        Windows with matching fullscreenstate. `0` - none, `1` -
                        maximize, `2` - fullscreen, `3` - maximize and fullscreen.
                      '';
                      example = 1;
                    };
                    workspace = lib.mkOption {
                      type = nullOr str;
                      default = null;
                      description = ''
                        Windows on matching workspace. Can be id, `"name:string"`
                        or a workspace selector.
                      '';
                      example = "name:my-workspace";
                    };
                    content = lib.mkOption {
                      type = nullOr (enum [
                        "none"
                        "photo"
                        "video"
                        "game"
                      ]);
                      default = null;
                      description = ''
                        Windows with specified content type (`"none"`, `"photo"`,
                        `"video"`, `"game"`).
                      '';
                      example = "game";
                    };
                    xdg_tag = lib.mkOption {
                      type = nullOr str;
                      default = null;
                      description = ''
                        Match a window by its xdgTag (see hyprctl clients to
                        check if it has one).
                      '';
                      example = "my-xdg-tag";
                    };
                  };
                  # TODO: Find a way to include assertions here
                  # config.assertions = [
                  #   {
                  #     assertion = config != { } && config != null;
                  #     message = "A window rule must have at least 1 matcher.";
                  #   }
                  # ];
                };
              default = { };
            };

            float = lib.mkOption {
              type = nullOr bool;
              default = null;
              description = "Floats a window.";
              example = true;
            };
            tile = lib.mkOption {
              type = nullOr bool;
              default = null;
              description = "Tiles a window.";
              example = true;
            };
            fullscreen = lib.mkOption {
              type = nullOr bool;
              default = null;
              description = "Fullscreens a window.";
              example = true;
            };
            maximize = lib.mkOption {
              type = nullOr bool;
              default = null;
              description = "Maximizes a window.";
              example = true;
            };
            fullscreen_state = lib.mkOption {
              type = nullOr str;
              default = null;
              description = ''
                Sets the fullscreen mode, e.g. `"1 2"` (internal client). Values:
                `0` none, `1` maximize, `2` fullscreen, `3` maximize and
                fullscreen.
              '';
              example = 1;
            };
            move = lib.mkOption {
              type = nullOr str;
              default = null;
              description = ''
                Moves a floating window to a given coordinate, monitor-local.
                E.g. `"100 200"` or `"(cursor_x - (window_w * 0.5)) (cursor_y -
                (window_h * 0.5))"`.

                Expressions can use the following variables:
                - `monitor_w` and `monitor_h` for monitor size
                - `window_x` and `window_y` for window position
                - `window_w` and `window_h` for window size
                - `cursor_x` and `cursor_y` for cursor position
              '';
              example = "(cursor_x - (window_w * 0.5)) (cursor_y - (window_h * 0.5))";
            };
            size = lib.mkOption {
              type = nullOr (either str (listOf int));
              default = null;
              description = ''
                Resizes a floating window. E.g. `"{800 600}"` or `"(monitor_w *
                0.5) (monitor_h * 0.5)"`.

                Expressions can use the following variables:
                - `monitor_w` and `monitor_h` for monitor size
                - `window_x` and `window_y` for window position
                - `window_w` and `window_h` for window size
                - `cursor_x` and `cursor_y` for cursor position
              '';
              example = "(monitor_w * 0.5) (monitor_h * 0.5)";
            };
            center = lib.mkOption {
              type = nullOr bool;
              default = null;
              description = ''
                If the window is floating, will center it on the monitor.
              '';
              example = true;
            };
            pseudo = lib.mkOption {
              type = nullOr bool;
              default = null;
              description = "Pseudotiles a window.";
              example = true;
            };
            monitor = lib.mkOption {
              type = nullOr str;
              default = null;
              description = ''
                Sets the monitor on which a window should open. E.g. `"1"` or
                `"DP-1"`.
              '';
              example = "DP-1";
            };
            workspace = lib.mkOption {
              type = nullOr str;
              default = null;
              description = ''
                Sets the workspace on which a window should open. Can also be
                `"unset"` or suffixed with `"silent"`.
              '';
              example = "my-workspace";
            };
            no_initial_focus = lib.mkOption {
              type = nullOr bool;
              default = null;
              description = "Disables the initial focus to the window.";
              example = true;
            };
            pin = lib.mkOption {
              type = nullOr bool;
              default = null;
              description = ''
                Pins the window (i.e. show it on all workspaces). _Note: floating
                only._
              '';
              example = true;
            };
            group = lib.mkOption {
              type = nullOr str;
              default = null;
              description = ''
                Sets window group properties. See group options below.

                Takes a string with space-separated options:

                `"set"` [`"always"`] - Open window as a group.
                `"new"` - Shorthand for `"barred set"`.
                `"lock"` [`"always"`] - Lock the group. Combine with `"set"` or `"new"`.
                `"barred"` - Do not automatically group into the focused unlocked group.
                `"deny"` - Do not allow the window to be toggled as or added to a group.
                `"invade"` - Force open window in the locked group.
                `"override"` [other options] - Override other `group` rules.
                `"unset"` - Clear all `group` rules.
              '';
              example = "set new lock always";
            };
            suppress_event = lib.mkOption {
              type = nullOr str;
              default = null;
              description = ''
                Ignores specific events. Space-separated: `"fullscreen"`,
                `"maximize"`, `"activate"`, `"activatefocus"`,
                `"fullscreenoutput"`.
              '';
              example = "fullscreen maximize";
            };
            content = lib.mkOption {
              type = nullOr (enum [
                "none"
                "photo"
                "video"
                "game"
              ]);
              default = null;
              description = ''
                Sets content type: `"none"`, `"photo"`, `"video"`, or `"game"`.
              '';
              example = "game";
            };
            no_close_for = lib.mkOption {
              type = nullOr int;
              default = null;
              description = ''
                Makes the window uncloseable with `killactive` for a given number
                of ms on open.
              '';
              example = 1000;
            };
            scrolling_width = lib.mkOption {
              type = nullOr int;
              default = null;
              description = ''
                Set column width for window when starting on a workspace with
                the scrolling layout.
              '';
              example = 80;
            };

            persistent_size = lib.mkOption {
              type = nullOr bool;
              description = ''
                For floating windows, internally store their size. When a new
                floating window opens with the same class and title, restore
                the saved size.
              '';
              default = null;
            };
            no_max_size = lib.mkOption {
              type = nullOr bool;
              description = ''
                Removes max size limitations.
              '';
              default = null;
            };
            stay_focused = lib.mkOption {
              type = nullOr bool;
              description = ''
                Forces focus on the window as long as it’s visible.
              '';
              default = null;
            };
            animation = lib.mkOption {
              type = nullOr str;
              description = ''
                Forces an animation onto a window with an optional style. E.g.
                `"popin"` or `"popin 80%"`.
              '';
              default = null;
            };
            border_color = lib.mkOption {
              type = nullOr (oneOf [
                str
                (submodule {
                  options = {
                    colors = lib.mkOption {
                      description = "Gradient colors";
                      type = listOf str;
                      example = [
                        "rgba(33ccffee)"
                        "rgba(00ff99ee)"
                      ];
                    };
                    angle = lib.mkOption {
                      description = "Angle of the gradient";
                      type = float;
                      example = 45;
                    };
                  };
                })
              ]);
              description = ''
                Force the border color. Accepts a color, gradient, or two
                gradients (active/inactive).

                E.g. `"rgb(FF0000)"` or `{ colors = ["rgba(33ccffee)"
                "rgba(00ff99ee)"]; angle = 45; }`.
              '';
              default = null;
            };
            idle_inhibit = lib.mkOption {
              type = nullOr (enum [
                "none"
                "always"
                "focus"
                "fullscreen"
              ]);
              description = ''
                Sets an idle inhibit rule. Modes: `"none"`, `"always"`,
                `"focus"`, `"fullscreen"`.
              '';
              default = null;
            };
            opacity = lib.mkOption {
              type = nullOr str;
              description = ''
                Additional opacity multiplier.

                E.g.:
                - Overall: `"0.8"`
                - Active/inactive: `"0.9 0.7"`
                - Active/inactive/fullscreen: `"1.0 0.8 0.9"`

                Append `" override"` after each value to set absolute instead
                of multiplied.
              '';
              default = null;
            };
            tag = lib.mkOption {
              type = nullOr str;
              description = ''
                Applies a tag. Use prefix `+`/`-` to set/unset, or no prefix to
                toggle. E.g. `"+myTag"`.
              '';
              default = null;
            };
            max_size = lib.mkOption {
              type = nullOr (listOf ints.positive);
              description = ''
                Sets the maximum size for floating windows. E.g. { 800, 600 }.
              '';
              default = null;
              example = [
                800
                600
              ];
            };
            min_size = lib.mkOption {
              type = nullOr (listOf ints.positive);
              description = ''
                Sets the minimum size for floating windows. E.g. { 200, 150 }.
              '';
              default = null;
              example = [
                200
                150
              ];
            };
            border_size = lib.mkOption {
              type = nullOr int;
              description = ''
                Sets the border size.
              '';
              default = null;
            };
            rounding = lib.mkOption {
              type = nullOr int;
              description = ''
                Forces X pixels of rounding, ignoring the default.
              '';
              default = null;
            };
            rounding_power = lib.mkOption {
              type = nullOr float;
              description = ''
                Overrides the rounding power for the window.
              '';
              default = null;
            };
            allows_input = lib.mkOption {
              type = nullOr bool;
              description = ''
                Forces an XWayland window to receive input even if it requests
                not to.
              '';
              default = null;
            };
            dim_around = lib.mkOption {
              type = nullOr bool;
              description = ''
                Dims everything around the window. Meant for floating windows.
              '';
              default = null;
            };
            decorate = lib.mkOption {
              type = nullOr bool;
              description = ''
                Whether to draw window decorations. (default: `true`)
              '';
              default = null;
            };
            focus_on_activate = lib.mkOption {
              type = nullOr bool;
              description = ''
                Whether Hyprland should focus an app that requests to be
                focused.
              '';
              default = null;
            };
            keep_aspect_ratio = lib.mkOption {
              type = nullOr bool;
              description = ''
                Forces aspect ratio when resizing with the mouse.
              '';
              default = null;
            };
            nearest_neighbor = lib.mkOption {
              type = nullOr bool;
              description = ''
                Forces nearest-neighbor filtering.
              '';
              default = null;
            };
            no_anim = lib.mkOption {
              type = nullOr bool;
              description = ''
                Disables animations for the window.
              '';
              default = null;
            };
            no_blur = lib.mkOption {
              type = nullOr bool;
              description = ''
                Disables blur for the window.
              '';
              default = null;
            };
            no_dim = lib.mkOption {
              type = nullOr bool;
              description = ''
                Disables window dimming for the window.
              '';
              default = null;
            };
            no_focus = lib.mkOption {
              type = nullOr bool;
              description = ''
                Disables focus to the window.
              '';
              default = null;
            };
            no_follow_mouse = lib.mkOption {
              type = nullOr bool;
              description = ''
                Prevents the window from being focused when the mouse moves
                over it when `input.follow_mouse=1` is set.
              '';
              default = null;
            };
            no_shadow = lib.mkOption {
              type = nullOr bool;
              description = ''
                Disables shadows for the window.
              '';
              default = null;
            };
            no_shortcuts_inhibit = lib.mkOption {
              type = nullOr bool;
              description = ''
                Disallows the app from inhibiting your shortcuts.
              '';
              default = null;
            };
            no_screen_share = lib.mkOption {
              type = nullOr bool;
              description = ''
                Hides the window and its popups from screen sharing by drawing
                black rectangles in their place.
              '';
              default = null;
            };
            no_vrr = lib.mkOption {
              type = nullOr bool;
              description = ''
                Disables VRR for the window. Only works when `misc.vrr` is set
                to `2` or `3`.
              '';
              default = null;
            };
            opaque = lib.mkOption {
              type = nullOr bool;
              description = ''
                Forces the window to be opaque.
              '';
              default = null;
            };
            force_rgbx = lib.mkOption {
              type = nullOr bool;
              description = ''
                Forces Hyprland to ignore the alpha channel entirely.
              '';
              default = null;
            };
            sync_fullscreen = lib.mkOption {
              type = nullOr bool;
              description = ''
                Whether the fullscreen mode should always be the same as the
                one sent to the window.
              '';
              default = null;
            };
            immediate = lib.mkOption {
              type = nullOr bool;
              description = ''
                Forces the window to allow tearing.
              '';
              default = null;
            };
            xray = lib.mkOption {
              type = nullOr bool;
              description = ''
                Sets blur xray mode for the window.
              '';
              default = null;
            };
            render_unfocused = lib.mkOption {
              type = nullOr bool;
              description = ''
                Forces the window to think it’s being rendered when it’s not
                visible.
              '';
              default = null;
            };
            scroll_mouse = lib.mkOption {
              type = nullOr float;
              description = ''
                Forces the window to override `input.scroll_factor`.
              '';
              default = null;
            };
            scroll_touchpad = lib.mkOption {
              type = nullOr float;
              description = ''
                Forces the window to override `input.touchpad.scroll_factor`.
              '';
              default = null;
            };
            confine_pointer = lib.mkOption {
              type = nullOr bool;
              description = ''
                Locks the mouse cursor to the window. Mostly useful for keeping
                your mouse cursor locked to one monitor during gaming.
              '';
              default = null;
            };
          };
        });
    };
    layerRules = lib.mkOption {
      description = "Rules for wayland layer elements";
      example = [
        {
          match.class = "my-class";
          float = true;
        }
      ];
      default = [ ];
      type =
        with lib.types;
        listOf (submodule {
          name = lib.mkOption {
            description = "Name for the layer rule";
            type = nullOr str;
            default = null;
            example = "my-rule";
          };

          match = lib.mkOption {
            description = "Matchers for the given layer rule. All matches must match a layer to apply the effects.";
            default = { };
            type = submodule {
              options = {
                namespace = lib.mkOption {
                  type = nullOr str;
                  default = null;
                  description = "Namespace of the layer. Check `hyprctl layers`.";
                  example = "my-namespace";
                };
              };
              # TODO: Find a way to include assertions here
              # config.assertions = [
              #   {
              #     assertion = config != { } && config != null;
              #     message = "At least one matcher must be specified for a layer rule.";
              #   }
              # ];
            };
          };
          no_anim = lib.mkOption {
            type = nullOr bool;
            default = null;
            description = "Disables animations.";
            example = true;
          };
          blur = lib.mkOption {
            type = nullOr bool;
            default = null;
            description = "Enables blur for the layer.";
            example = true;
          };
          blur_popups = lib.mkOption {
            type = nullOr bool;
            default = null;
            description = "Enables blur for popups.";
            example = true;
          };
          ignore_alpha = lib.mkOption {
            type = nullOr float;
            default = null;
            description = ''
              Makes blur ignore pixels with opacity of a or lower. Float from
              `0` to `1`.
            '';
            example = 0.2;
          };
          dim_around = lib.mkOption {
            type = nullOr bool;
            default = null;
            description = "Dims everything behind the layer.";
            example = true;
          };
          xray = lib.mkOption {
            type = nullOr bool;
            default = null;
            description = "Sets the blur xray mode for the layer.";
            example = true;
          };
          animation = lib.mkOption {
            type = nullOr str;
            default = null;
            description = "Sets a specific animation style for this layer.";
            example = "my-anim";
          };
          order = lib.mkOption {
            type = nullOr int;
            default = null;
            description = ''
              Sets the order relative to other layers. Higher `n` = closer to
              edge of monitor. Can be negative.
            '';
            example = 2;
          };
          above_lock = lib.mkOption {
            type = nullOr int;
            default = null;
            description = ''
              If non-zero, renders the layer above the lockscreen. `2` =
              interactive on lockscreen.
            '';
            example = 2;
          };
          no_screen_share = lib.mkOption {
            type = nullOr bool;
            default = null;
            description = "Hides the layer from screen sharing.";
            example = true;
          };
        });
    };
  };
  hm = {
    gipphe.programs.hyprland.settings.rendered =
      lib.optionalString (cfg.settings.layerRules != [ ]) (
        builtins.concatStringsSep "\n" (map toLayerRule cfg.settings.layerRules)
      )
      + "\n"
      + lib.optionalString (cfg.settings.windowRules != [ ]) (
        builtins.concatStringsSep "\n" (map toWindowRule cfg.settings.windowRules)
      );
  };
}
