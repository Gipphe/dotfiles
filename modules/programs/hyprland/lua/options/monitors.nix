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
  toMonitorDef = monitor: "hl.monitor(${toLua (removeNullAttrs monitor)})";
in
util.mkModule {
  options.gipphe.programs.hyprland.settings.monitors = lib.mkOption {
    description = "Monitors";
    type =
      with lib.types;
      listOf (submodule {
        options = {
          output = lib.mkOption {
            type = str;
            description = "Output name or `desc:...` description prefix";
            example = "DP-1";
          };
          mode = lib.mkOption {
            type = nullOr str;
            default = null;
            description = "Resolution and refresh rate, e.g. `1920x1080@144`";
            example = "1920x1080@144";
          };
          position = lib.mkOption {
            type = nullOr str;
            default = null;
            description = "Position in the virtual layout, e.g. `1920x0`";
            example = "1920x0";
          };
          scale = lib.mkOption {
            type = nullOr (either str float);
            default = null;
            description = "Scale factor, e.g. `1.5`";
            example = 1.5;
          };
          disabled = lib.mkOption {
            type = nullOr bool;
            default = null;
            description = "Removes the monitor from the layout";
            example = true;
          };
          transform = lib.mkOption {
            type = nullOr (ints.between 0 7);
            default = null;
            description = ''
              Rotation/flip transform (0–7)

              - 0: normal (no transforms)
              - 1: 90 degrees
              - 2: 180 degrees
              - 3: 270 degrees
              - 4: flipped
              - 5: flipped + 90 degrees
              - 6: flipped + 180 degrees
              - 7: flipped + 270 degrees
            '';
            example = 1;
          };
          mirror = lib.mkOption {
            type = nullOr str;
            default = null;
            description = "Output name to mirror";
            example = "DP-2";
          };
          bitdepth = lib.mkOption {
            type = nullOr (enum [
              8
              10
            ]);
            default = null;
            description = "Bit depth (8 or 10)";
            example = 10;
          };
          cm = lib.mkOption {
            type = nullOr str;
            default = null;
            description = "Color management preset";
            example = "srgb";
          };
          sdr_eotf = lib.mkOption {
            type = nullOr (enum [
              "default"
              "gamma22"
              "srgb"
            ]);
            default = null;
            description = "SDR transfer function (default, gamma22, srgb)";
            example = "gamma22";
          };
          sdrbrightness = lib.mkOption {
            type = nullOr float;
            default = null;
            description = "SDR brightness in HDR mode";
            example = 1.2;
          };
          sdrsaturation = lib.mkOption {
            type = nullOr float;
            default = null;
            description = "SDR saturation in HDR mode";
            example = 1.2;
          };
          vrr = lib.mkOption {
            type = nullOr int;
            default = null;
            description = "VRR mode";
            example = 1;
          };
          icc = lib.mkOption {
            type = nullOr str;
            default = null;
            description = ''
              Absolute path to an ICC profile.

              Please note:

              - Path needs to be absolute.
              - Having an ICC applied will automatically force `sdr_eotf` to
                `sRGB` for that monitor (for color accuracy).
              - Having an ICC applied overrides the CM preset.
              - ICCs are fundamentally incompatible with HDR gaming. Funky
                stuff may happen.
            '';
            example = "/path/to/icc.icm";
          };
          reserved_area = lib.mkOption {
            type = nullOr (
              either int (submodule {
                options =
                  let
                    resOpt =
                      side:
                      lib.mkOption {
                        type = int;
                        description = "Reserved area for ${side}";
                        example = 2;
                      };
                  in
                  {
                    top = resOpt "top";
                    right = resOpt "right";
                    bottom = resOpt "bottom";
                    left = resOpt "left";
                  };
              })
            );
            default = null;
            description = "Reserved area - integer for all sides, or table with top/right/bottom/left";
            example = 2;
          };
          supports_wide_color = lib.mkOption {
            type = nullOr (enum [
              (-1)
              0
              1
            ]);
            default = null;
            description = "Force wide color gamut (-1 = off, 0 = auto, 1 = on)";
            example = 1;
          };
          supports_hdr = lib.mkOption {
            type = nullOr (enum [
              (-1)
              0
              1
            ]);
            default = null;
            description = "Force HDR support (-1 = off, 0 = auto, 1 = on)";
            example = 1;
          };
          sdr_min_luminance = lib.mkOption {
            type = nullOr float;
            default = null;
            description = "SDR minimum luminance for SDR→HDR mapping";
            example = 0.4;
          };
          sdr_max_luminance = lib.mkOption {
            type = nullOr float;
            default = null;
            description = "SDR maximum luminance";
            example = 90;
          };
          min_luminance = lib.mkOption {
            type = nullOr float;
            default = null;
            description = "Monitor minimum luminance";
            example = 0.5;
          };
          max_luminance = lib.mkOption {
            type = nullOr int;
            default = null;
            description = "Monitor maximum possible luminance";
            example = 0.9;
          };
          max_avg_luminance = lib.mkOption {
            type = nullOr int;
            default = null;
            description = "Monitor maximum average luminance";
            example = 50;
          };
        };
      });
    default = [ ];
    example = lib.literalExpression ''
      [
        {
          output = "DP-1";
          mode = "1920x1080@144";
          position = "0x0";
          scale = 1;
        }
      ]
    '';
  };
  hm = {
    gipphe.programs.hyprland.settings.rendered = lib.mkIf (cfg.settings.monitors != [ ]) (
      builtins.concatStringsSep "\n" (map toMonitorDef cfg.settings.monitors)
    );
  };
}
