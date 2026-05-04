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
  toWorkspaceRule = rule: "hl.workspace_rule(${toLua (removeNullAttrs rule)})";
in
util.mkModule {
  options.gipphe.programs.hyprland.settings.workspaceRules = lib.mkOption {
    description = "Rules to apply to workspces";
    default = [ ];
    example = [
      {
        workspace = "3";
        no_rounding = true;
        decorate = false;
      }
      {
        workspace = "name:coding";
        no_rounding = true;
        decorate = false;
        gaps_in = 0;
        gaps_out = 0;
        no_border = true;
        monitor = "DP-1";
      }
      {
        workspace = "8";
        border_size = 8;
      }
      {
        workspace = "name:Hello";
        monitor = "DP-1";
        default = true;
      }
      {
        workspace = "name:gaming";
        monitor = "desc:Chimei Innolux Corporation 0x150C";
        default = true;
      }
      {
        workspace = "5";
        on_created_empty = "[float] firefox";
      }
      {
        workspace = "special:scratchpad";
        on_created_empty = "foot";
      }
      {
        workspace = "15";
        animation = "slidevert";
        default_name = "slider";
      }
    ];
    type =
      with lib.types;
      listOf (submodule {
        options = {
          workspace = lib.mkOption {
            description = "Workspace to apply the rule to.";
            type = str;
            example = "3";
          };
          monitor = lib.mkOption {
            description = ''
              Binds a workspace to a monitor. See
              [syntax](https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/#syntax)
              and [Monitors](https://wiki.hypr.land/Configuring/Basics/Monitors).
            '';
            type = nullOr str;
            default = null;
            example = "DP-1";
          };
          default = lib.mkOption {
            description = ''
              Whether this workspace should be the default workspace for the
              given monitor.
            '';
            type = nullOr bool;
            default = null;
            example = true;
          };
          gaps_in = lib.mkOption {
            description = ''
              Set the gaps between windows (equivalent to
              [General->gaps_in](https://wiki.hypr.land/Configuring/Basics/Variables#general))
            '';
            type = nullOr int;
            default = null;
            example = 2;
          };
          gaps_out = lib.mkOption {
            description = ''
              Set the gaps between windows and monitor edges (equivalent to
              [General->gaps_out](https://wiki.hypr.land/Configuring/Basics/Variables#general))
            '';
            type = nullOr int;
            default = null;
            example = 2;
          };
          border_size = lib.mkOption {
            description = ''
              Set the border size around windows (equivalent to
              [General->border_size](https://wiki.hypr.land/Configuring/Basics/Variables#general))
            '';
            type = nullOr int;
            default = null;
            example = 2;
          };
          no_border = lib.mkOption {
            description = "Whether to disable borders";
            type = nullOr bool;
            default = null;
            example = true;
          };
          no_shadow = lib.mkOption {
            description = "Whether to disable shadows";
            type = nullOr bool;
            default = null;
            example = true;
          };
          no_rounding = lib.mkOption {
            description = "Whether to disable rounded windows";
            type = nullOr bool;
            default = null;
            example = true;
          };
          decorate = lib.mkOption {
            description = "Whether to draw window decorations or not";
            type = nullOr bool;
            default = null;
            example = true;
          };
          persistent = lib.mkOption {
            description = "Keep this workspace alive even if empty and inactive";
            type = nullOr bool;
            default = null;
            example = true;
          };
          on_created_empty = lib.mkOption {
            description = ''
              A command to be executed once a workspace is created empty (i.e.
              not created by moving a window to it). See the 
              [command syntax](https://wiki.hypr.land/Configuring/Basics/Dispatchers#executing-with-rules)
            '';
            type = nullOr str;
            default = null;
            example = ''hl.dsp.exec_cmd("echo foo")'';
          };
          default_name = lib.mkOption {
            description = "A default name for the workspace.";
            type = nullOr str;
            default = null;
            example = "my-workspace";
          };
          layout = lib.mkOption {
            description = "The layout to use for this workspace.";
            type = nullOr str;
            default = null;
            example = "scrolling";
          };
          animation = lib.mkOption {
            description = "The animation style to use for this workspace.";
            type = nullOr str;
            default = null;
          };
        };
      });
  };
  hm = {
    gipphe.programs.hyprland.settings.rendered = lib.mkIf (cfg.settings.workspaceRules != [ ]) (
      builtins.concatStringsSep "\n" (map toWorkspaceRule cfg.settings.workspaceRules)
    );
  };
}
