{
  config,
  inputs,
  pkgs,
  lib,
  util,
  ...
}:
let
  package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
  portalPackage =
    inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
in
util.mkProgram {
  name = "hyprland";
  homeManager = {
    imports = [
      ./binds.nix
      ./env.nix
      ./input.nix
      ./triggers.nix
    ];
    config = {
      gipphe.core.wm.actions =
        let
          hyprctl = lib.getExe' package "hyprctl";
        in
        {
          monitors-on = "${hyprctl} dispatch 'hl.dsp.dpms { action = \"on\" }'";
          monitors-off = "${hyprctl} dispatch 'hl.dsp.dpms { action = \"off\" }'";
        };
      wayland.windowManager.hyprland = {
        enable = true;
        inherit package portalPackage;
        xwayland.enable = true;
        configType = "lua";
        settings = {
          monitor = [
            {
              output = "";
              mode = "preferred";
              position = "auto";
              scale = "1";
            }
          ];

          curve = [
            {
              _args = [
                "myBezier"
                {
                  type = "bezier";
                  points = [
                    [
                      0.05
                      0.9
                    ]
                    [
                      0.1
                      1.05
                    ]
                  ];
                }
              ];
            }
            {
              _args = [
                "easeOutQuart"
                {
                  type = "bezier";
                  points = [
                    [
                      0.25
                      1.0
                    ]
                    [
                      0.5
                      1.0
                    ]
                  ];
                }
              ];
            }
            {
              _args = [
                "easeInOutExpo"
                {
                  type = "bezier";
                  points = [
                    [
                      0.87
                      0.0
                    ]
                    [
                      0.13
                      1.0
                    ]
                  ];
                }
              ];
            }
          ];

          animation = [
            {
              enabled = true;
              leaf = "windows";
              speed = 3;
              bezier = "easeOutQuart";
            }
            {
              enabled = true;
              leaf = "windowsOut";
              speed = 3;
              bezier = "easeInOutExpo";
              style = "popin 80%";
            }
            {
              enabled = true;
              leaf = "border";
              speed = 5;
              bezier = "easeOutQuart";
            }
            {
              enabled = true;
              leaf = "borderangle";
              speed = 4;
              bezier = "easeOutQuart";
            }
            {
              enabled = true;
              leaf = "fade";
              speed = 4;
              bezier = "default";
            }
            {
              enabled = true;
              leaf = "workspaces";
              speed = 1;
              bezier = "default";
              style = "slidevert";
            }
          ];

          workspace_rule = [
            {
              workspace = "w[tv1]s[false]";
              gaps_in = 0;
              gaps_out = 0;
            }
            {
              workspace = "f[1]s[false]";
              gaps_in = 0;
              gaps_out = 0;
            }
          ];

          window_rule = [
            {
              match.float = false;
              match.workspace = "w[tv1]s[false]";
              border_size = 0;
              rounding = 0;
            }
            {
              match.float = false;
              match.workspace = "f[1]s[false]";
              border_size = 0;
              rounding = 0;
            }
          ];

          config = {
            cursor.no_hardware_cursors = true;
            animations.enabled = true;

            general = {
              gaps_in = 2;
              gaps_out = 2;
              border_size = 1;
              "col.active_border" = lib.mkForce {
                colors = [
                  "rgb(8aadf4)"
                  "rgb(c6a0f6)"
                ];
                angle = 45;
              };
              layout = "dwindle";
              resize_on_border = true;
            };

            decoration = {
              rounding = 6;
              blur = {
                enabled = true;
                size = 3;
                passes = 1;
              };

              shadow = {
                enabled = true;
                range = 4;
                render_power = 3;
              };
            };

            dwindle = {
              preserve_split = true;
            };

            gestures = {
              workspace_swipe_touch = true;
              workspace_swipe_create_new = true;
            };

            misc = {
              disable_hyprland_logo = true;
              disable_splash_rendering = true;
            };
          };
        };
      };
      home.packages = [
        (pkgs.writeShellScriptBin "hyprstart" ''
          ${config.wayland.windowManager.hyprland.package}/bin/hyprctl dispatch "hl.dsp.exec_cmd('$1')"
        '')
      ];
    };
  };
  nixos = {
    programs.hyprland = {
      enable = true;
      inherit package portalPackage;
    };
  };
}
