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
  };
  homeManager.home.packages = [
    cfg.package
    (util.writeNushellApplication {
      name = "record";
      runtimeInputs = [
        pkgs.slurp
        pkgs.ffmpeg
        cfg.package
        config.wayland.windowManager.hyprland.package
      ];
      text = builtins.readFile ./record.nu;
    })
  ];
}
