{
  util,
  lib,
  config,
  ...
}:
let
  inherit (import ./utils.nix) removeNullAttrs;
  cfg = config.gipphe.programs.hyprland;
  toLua = lib.generators.toLua { };
  toAnimation = animation: ''
    hl.animation(${toLua (removeNullAttrs animation)})
  '';
  toCurve = curveName: curve: ''
    hl.curve(${toLua curveName}, ${toLua (removeNullAttrs curve)})
  '';
  lit = x: lib.types.enum [ x ];
in
util.mkModule {
  options.gipphe.programs.hyprland.settings = {
    animations = lib.mkOption {
      description = "Animations";
      default = [ ];
      example = [
        {
          leaf = "workspaces";
          enabled = true;
          speed = 8;
          bezier = "my_epic_bezier";
        }
      ];
      type =
        with lib.types;
        listOf (submodule {
          options = {
            leaf = lib.mkOption {
              description = ''
                The scope of the animation. See [animation
                tree](https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/#animation-tree).
              '';
              type = str;
              example = "workspaces";
            };
            enabled = lib.mkOption {
              description = "Enable or disable animation.";
              type = bool;
              default = true;
              example = false;
            };
            speed = lib.mkOption {
              description = "Number of ds this animation will take. 1 ds = 100 ms";
              type = int;
              example = 2;
            };
            bezier = lib.mkOption {
              description = "Curve name";
              type = nullOr str;
              default = null;
              example = "my-curve";
            };
            spring = lib.mkOption {
              description = "Spring name";
              type = nullOr str;
              default = null;
              example = "my-spring";
            };
            style = lib.mkOption {
              description = "Animation style";
              type = nullOr str;
              default = null;
              example = "slide";
            };
          };
          # TODO: Find a way to include assertions here.
          # config.assertions = [
          #   {
          #     assertion =
          #       config.enabled
          #       && (
          #         (config.bezier != null && config.spring == null) || (config.bezier == null && config.spring != null)
          #       );
          #     message = "Either spring or bezier have to be defined when the animation is enabled.";
          #   }
          # ];
        });
    };

    curves = lib.mkOption {
      description = "Curve definitions";
      default = { };
      example = {
        "my-bezier" = {
          type = "bezier";
          points = [
            [
              0
              0.2
            ]
            [
              1
              1
            ]
          ];
        };
        "my-spring" = {
          type = "spring";
          mass = 1;
          stiffness = 70;
          dampening = 10;
        };
      };
      type =
        with lib.types;
        attrsWith {
          placeholder = "curve-name";
          elemType = oneOf [
            (submodule {
              options = {
                type = lib.mkOption {
                  description = "Curve type";
                  type = lit "bezier";
                  example = "bezier";
                };
                points = lib.mkOption {
                  description = "Points for the bezier curve";
                  type = listOf (listOf float);
                  example = [
                    [
                      0.5
                      0.9
                    ]
                    [
                      0.1
                      1.1
                    ]
                  ];
                };
              };
            })
            (submodule {
              options = {
                type = lib.mkOption {
                  description = "Curve type";
                  type = lit "spring";
                  example = "spring";
                };
                mass = lib.mkOption {
                  description = ''
                    Mass of the spring. It is advisable to just set this to
                    1 and adjust stiffness and dampening instead.
                  '';
                  type = float;
                  example = 1;
                };
                stiffness = lib.mkOption {
                  description = ''
                    Stiffness of the spring animation. Defines the force
                    used in the motion of the animation.
                  '';
                  type = float;
                  example = 70;
                };
                dampening = lib.mkOption {
                  description = ''
                    Dampening of the spring animation. Defines how quickly
                    forces from the stiffness are dissipated in the motion
                    of the animation.
                  '';
                  type = float;
                  example = 10;
                };
              };
            })
          ];
        };
    };
  };

  hm = {
    gipphe.programs.hyprland.settings.rendered = lib.mkMerge [
      (lib.mkIf (cfg.settings.curves != [ ]) ''
        ${builtins.concatStringsSep "\n" (lib.mapAttrsToList toCurve cfg.settings.curves)}
      '')
      (lib.mkIf (cfg.settings.animations != [ ]) ''
        ${builtins.concatStringsSep "\n" (map toAnimation cfg.settings.animations)}
      '')
    ];
  };
}
