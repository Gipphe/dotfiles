{
  den.aspects.programs.wf-recorder.homeManager =
    { pkgs, config, ... }:
    let
      pkg = pkgs.wf-recorder;
    in
    {
      home.packages = [
        pkg
        (pkgs.writeNushellApplication {
          name = "record";
          runtimeInputs = [
            pkgs.slurp
            pkgs.ffmpeg
            pkg
            config.wayland.windowManager.hyprland.package
          ];
          text = builtins.readFile ./record.nu;
        })
      ];
    };
}
