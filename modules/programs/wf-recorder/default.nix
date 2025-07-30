{
  pkgs,
  lib,
  config,
  util,
  ...
}:
let
  cfg = config.gipphe.programs.wf-recorder;
in
util.mkProgram {
  name = "wf-recorder";
  options.gipphe.programs.wf-recorder = {
    package = lib.mkPackageOption pkgs "wf-recorder" { };
    nicknames = lib.mkOption {
      type = with lib.types; attrsOf str;
      description = "Unique descriptions and their corresponding nicknames.";
      default = { };
      example = {
        "Dell Inc. DELL U2724D G11T4Z3" = "center";
        "Dell Inc. DELL U2724D G27V4Z3" = "right";
        "Dell Inc. DELL U2724D G15V4Z3" = "left";
      };
    };
  };
  hm.home.packages = [
    cfg.package
    (util.writeFishApplication {
      name = "record";
      runtimeInputs = with pkgs; [
        busybox
        cfg.package
        config.wayland.windowManager.hyprland.package
        coreutils
        ffmpeg
        gum
        slurp
      ];
      runtimeEnv = {
        nicknames = builtins.toJSON cfg.nicknames;
        window_border = config.wayland.windowManager.hyprland.settings.general."col.active_border";
      };
      text = builtins.readFile ./record.fish;
    })
  ];
}
