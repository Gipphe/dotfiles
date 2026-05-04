{
  lib,
  util,
  config,
  ...
}:
let
  inherit (import ./utils.nix) removeNullAttrs;
  cfg = config.gipphe.programs.hyprland;
  toLua = lib.generators.toLua { };
  toDevice = device: "hl.device(${toLua (removeNullAttrs device)})";
in
util.mkModule {
  options.gipphe.programs.hyprland.settings.devices = lib.mkOption {
    description = "Per-device configuration";
    example = [
      {
        name = "my-epic-keyboard";
        sensitivity = -0.5;
      }
    ];
    default = [ ];
    type =
      with lib.types;
      listOf (submodule {
        options = {
          name = lib.mkOption {
            description = "Name of the device to apply this configuration to.";
            type = str;
            example = "my-epic-keyboard";
          };
          enabled = lib.mkEnableOption "the device." // {
            default = true;
          };
          keybinds = lib.mkEnableOption "key bindings for this device." // {
            default = true;
          };
          kb_model = lib.mkOption {
            description = ''
              Appropriate XKB keymap parameter. See the note
              [below](https://wiki.hypr.land/Configuring/Basics/Variables/#input).
            '';
            type = nullOr str;
            default = null;
          };
          kb_layout = lib.mkOption {
            description = "Appropriate XKB keymap parameter";
            type = nullOr str;
            default = null;
          };
          kb_variant = lib.mkOption {
            description = "Appropriate XKB keymap parameter";
            type = nullOr str;
            default = null;
          };
          kb_options = lib.mkOption {
            description = "Appropriate XKB keymap parameter";
            type = nullOr str;
            default = null;
          };
          kb_rules = lib.mkOption {
            description = "Appropriate XKB keymap parameter";
            type = nullOr str;
            default = null;
          };
          kb_file = lib.mkOption {
            description = ''
              If you prefer, you can use a path to your custom .xkb file.
            '';
            type = nullOr str;
            default = null;
          };
          numlock_by_default = lib.mkOption {
            description = "Engage numlock by default.";
            type = nullOr bool;
            default = null;
          };
          resolve_binds_by_sym = lib.mkOption {
            description = ''
              Determines how keybinds act when multiple layouts are used. If
              false, keybinds will always act as if the first specified layout
              is active. If true, keybinds specified by symbols are activated
              when you type the respective symbol with the current layout.
            '';
            type = nullOr bool;
            default = null;
          };
          repeat_rate = lib.mkOption {
            description = ''
              The repeat rate for held-down keys, in repeats per second.
            '';
            type = nullOr int;
            default = null;
          };
          repeat_delay = lib.mkOption {
            description = ''
              Delay before a held-down key is repeated, in milliseconds.
            '';
            type = nullOr int;
            default = null;
          };
          sensitivity = lib.mkOption {
            description = ''
              Sets the mouse input sensitivity. Value is clamped to the range
              -1.0 to 1.0.
              [libinput#pointer-acceleration](https://wayland.freedesktop.org/libinput/doc/latest/pointer-acceleration.html#pointer-acceleration)
            '';
            type = nullOr float;
            default = null;
          };
          accel_profile = lib.mkOption {
            description = ''
              Sets the cursor acceleration profile. Can be one of `adaptive`,
              `flat`. Can also be `custom`, see
              [below](https://wiki.hypr.land/Configuring/Basics/Variables/#accel_profile).
              Leave empty to use `libinput`'s default mode for your input
              device.
              [libinput#pointer-acceleration](https://wayland.freedesktop.org/libinput/doc/latest/pointer-acceleration.html#pointer-acceleration)
              [adaptive/flat/custom]
            '';
            type = nullOr (enum [
              "adaptive"
              "flat"
              "custom"
            ]);
            default = null;
          };
          rotation = lib.mkOption {
            description = ''
              Sets the rotation of a device in degrees clockwise off the
              logical neutral position. Value is clamped to the range 0 to 359.
            '';
            type = nullOr int;
            default = null;
          };
          left_handed = lib.mkOption {
            description = "Switches RMB and LMB";
            type = nullOr bool;
            default = null;
          };
          scroll_points = lib.mkOption {
            description = ''
              Sets the scroll acceleration profile, when `accel_profile` is set
              to `custom`. Has to be in the form `<step> <points>`. Leave empty
              to have a flat scroll curve. See [below](https://wiki.hypr.land/Configuring/Basics/Variables/#scroll_points)
            '';
            type = nullOr str;
            default = null;
          };
          scroll_method = lib.mkOption {
            description = ''
              Sets the scroll method. Can be one of `2fg` (2 fingers), `edge`,
              `on_button_down`, `no_scroll`.
              [libinput#scrolling](https://wayland.freedesktop.org/libinput/doc/latest/scrolling.html)
              [2fg/edge/on_button_down/no_scroll]
            '';
            type = nullOr (enum [
              "2fg"
              "edge"
              "on_button_down"
              "no_scroll"
            ]);
            default = null;
          };
          scroll_button = lib.mkOption {
            description = ''
              Sets the scroll button. Has to be an int, cannot be a string.
              Check `wev` if you have any doubts regarding the ID. 0 means
              default.
            '';
            type = nullOr int;
            default = null;
          };
          scroll_button_lock = lib.mkOption {
            description = ''
              If the scroll button lock is enabled, the button does not need to
              be held down. Pressing and releasing the button toggles the
              button lock, which logically holds the button down or releases
              it. While the button is logically held down, motion events are
              converted to scroll events.
            '';
            type = nullOr bool;
            default = null;
          };
          scroll_factor = lib.mkOption {
            description = ''
              Multiplier added to scroll movement for external mice. Note that
              there is a separate setting for
              [touchpad scroll_factor](https://wiki.hypr.land/Configuring/Basics/Variables/#touchpad).
            '';
            type = nullOr float;
            default = null;
          };
          natural_scroll = lib.mkOption {
            description = ''
              Inverts scrolling direction. When enabled, scrolling moves
              content directly, rather than manipulating a scrollbar.
            '';
            type = nullOr bool;
            default = null;
          };
          off_window_axis_events = lib.mkOption {
            description = ''
              Handles axis events around (gaps/border for tiled,
              dragarea/border for floated) a focused window. `0` ignores axis
              events `1` sends out-of-bound coordinates `2` fakes pointer
              coordinates to the closest point inside the window `3` warps the
              cursor to the closest point inside the window.
            '';
            type = nullOr (ints.between 0 3);
            default = null;
          };
          emulate_discrete_scroll = lib.mkOption {
            description = ''
              Emulates discrete scrolling from high resolution scrolling
              events. `0` disables it, `1` enables handling of non-standard
              events only, and `2` force enables all scroll wheel events to be
              handled.
            '';
            type = nullOr (ints.between 0 2);
            default = null;
          };
          touchpad = lib.mkOption {
            description = "Touchpad-specific settings";
            default = null;
            example = {
              natural_scroll = true;
            };
            type = nullOr (submodule {
              options = {
                disable_while_typing = lib.mkOption {
                  description = ''
                    Disable the touchpad while typing.
                  '';
                  type = nullOr bool;
                  default = null;
                };
                natural_scroll = lib.mkOption {
                  description = ''
                    Inverts scrolling direction. When enabled, scrolling moves
                    content directly, rather than manipulating a scrollbar.
                  '';
                  type = nullOr bool;
                  default = null;
                };
                scroll_factor = lib.mkOption {
                  description = ''
                    Multiplier applied to the amount of scroll movement.
                  '';
                  type = nullOr float;
                  default = null;
                };
                middle_button_emulation = lib.mkOption {
                  description = ''
                    Sending LMB and RMB simultaneously will be interpreted as a middle click. This disables any touchpad area that would normally send a middle click based on location. [libinput#middle-button-emulation](https://wayland.freedesktop.org/libinput/doc/latest/middle-button-emulation.html)
                  '';
                  type = nullOr bool;
                  default = null;
                };
                tap_button_map = lib.mkOption {
                  description = ''
                    Sets the tap button mapping for touchpad button emulation.
                    Can be one of `lrm` (default) or `lmr` (Left, Middle, Right
                    Buttons). [lrm/lmr]
                  '';
                  type = nullOr (enum [
                    "lrm"
                    "lmr"
                  ]);
                  default = null;
                };
                clickfinger_behavior = lib.mkOption {
                  description = ''
                    Button presses with 1, 2, or 3 fingers will be mapped to
                    LMB, RMB, and MMB respectively. This disables
                    interpretation of clicks based on location on the touchpad.
                    [libinput#clickfinger-behavior](https://wayland.freedesktop.org/libinput/doc/latest/clickpad-softbuttons.html#clickfinger-behavior)
                  '';
                  type = nullOr bool;
                  default = null;
                };
                tap_to_click = lib.mkOption {
                  description = ''
                    Tapping on the touchpad with 1, 2, or 3 fingers will send
                    LMB, RMB, and MMB respectively.
                  '';
                  type = nullOr bool;
                  default = null;
                };
                drag_lock = lib.mkOption {
                  description = ''
                    When enabled, lifting the finger off while dragging will
                    not drop the dragged item. 0 -> disabled, 1 -> enabled with
                    timeout, 2 -> enabled sticky.
                    [libinput#tap-and-drag](https://wayland.freedesktop.org/libinput/doc/latest/tapping.html#tap-and-drag)
                  '';
                  type = nullOr (ints.between 0 2);
                  default = null;
                };
                tap_and_drag = lib.mkOption {
                  description = ''
                    Sets the tap and drag mode for the touchpad
                  '';
                  type = nullOr bool;
                  default = null;
                };
                flip_x = lib.mkOption {
                  description = ''
                    inverts the horizontal movement of the touchpad
                  '';
                  type = nullOr bool;
                  default = null;
                };
                flip_y = lib.mkOption {
                  description = ''
                    inverts the vertical movement of the touchpad
                  '';
                  type = nullOr bool;
                  default = null;
                };
                drag_3fg = lib.mkOption {
                  description = ''
                    enables three finger drag, 0 -> disabled, 1 -> 3 fingers, 2
                    -> 4 fingers
                    [libinput#drag-3fg](https://wayland.freedesktop.org/libinput/doc/latest/drag-3fg.html)
                  '';
                  type = nullOr (ints.between 0 2);
                  default = null;
                };
              };
            });
          };
          touchdevice = lib.mkOption {
            description = "Touchdevice-specific settings.";
            default = null;
            example = {
              transform = 2;
            };
            type = nullOr (submodule {
              options = {
                transform = lib.mkOption {
                  description = ''
                    Transform the input from touchdevices. The possible
                    transformations are the same as
                    [those of the monitors](https://wiki.hypr.land/Configuring/Basics/Monitors/#rotating).
                    `-1` means it’s unset.
                  '';
                  type = nullOr int;
                  default = null;
                };
                output = lib.mkOption {
                  description = ''
                    The monitor to bind touch devices. The default is auto-detection. To stop auto-detection, use an empty string or the “[[Empty]]” value.
                  '';
                  type = nullOr str;
                  default = null;
                };
                enabled = lib.mkOption {
                  description = ''
                    Whether input is enabled for touch devices.
                  '';
                  type = nullOr bool;
                  default = null;
                };
              };
            });
          };
          virtualkeyboard = lib.mkOption {
            description = "Virtual keyboard-specific settings.";
            default = null;
            example = {
              share_states = 1;
              release_pressed_on_close = true;
            };
            type = nullOr (submodule {
              options = {
                share_states = lib.mkOption {
                  description = ''
                    Unify key down states and modifier states with other keyboards. 0 -> no, 1 -> yes, 2 -> yes unless IME client.
                  '';
                  type = nullOr (ints.between 0 2);
                  default = null;
                };
                release_pressed_on_close = lib.mkOption {
                  description = ''
                    Release all pressed keys by virtual keyboard on close.
                  '';
                  type = nullOr bool;
                  default = null;
                };
              };
            });
          };
          tablet = lib.mkOption {
            description = "Tablet-specific settings.";
            default = null;
            example = {
              relative_input = true;
              region_position = [
                10
                10
              ];
              region_size = [
                200
                200
              ];
            };
            type = nullOr (submodule {
              options = {
                transform = lib.mkOption {
                  description = ''
                    Transform the input from tablets. The possible
                    transformations are the same as
                    [those of the monitors](https://wiki.hypr.land/Configuring/Basics/Monitors/#rotating).
                    `-1` means it’s unset.
                  '';
                  type = nullOr int;
                  default = null;
                };
                output = lib.mkOption {
                  description = ''
                    The monitor to bind tablets. Can be `current` or a monitor
                    name. Leave empty to map across all monitors.
                  '';
                  type = nullOr str;
                  default = null;
                };
                region_position = lib.mkOption {
                  description = ''
                    Position of the mapped region in monitor layout relative to
                    the top left corner of the bound monitor or all monitors.
                  '';
                  type = nullOr (listOf int);
                  default = null;
                };
                absolute_region_position = lib.mkOption {
                  description = ''
                    Whether to treat the `region_position` as an absolute
                    position in monitor layout. Only applies when `output` is
                    empty.
                  '';
                  type = nullOr bool;
                  default = null;
                };
                region_size = lib.mkOption {
                  description = ''
                    Size of the mapped region. When this variable is set,
                    tablet input will be mapped to the region. [0, 0] or
                    invalid size means unset.
                  '';
                  type = nullOr (listOf int);
                  default = null;
                };
                relative_input = lib.mkOption {
                  description = ''
                    Whether the input should be relative.
                  '';
                  type = nullOr bool;
                  default = null;
                };
                left_handed = lib.mkOption {
                  description = ''
                    If enabled, the tablet will be rotated 180 degrees.
                  '';
                  type = nullOr bool;
                  default = null;
                };
                active_area_size = lib.mkOption {
                  description = ''
                    Size of tablet’s active area in mm.
                  '';
                  type = nullOr (listOf int);
                  default = null;
                };
                active_area_position = lib.mkOption {
                  description = ''
                    Position of the active area in mm.
                  '';
                  type = nullOr (listOf int);
                  default = null;
                };
              };
            });
          };
        };
      });
  };

  hm = {
    gipphe.programs.hyprland.settings.rendered = lib.mkIf (cfg.settings.devices != [ ]) (
      builtins.concatStringsSep "\n" (map toDevice cfg.settings.devices)
    );
  };
}
