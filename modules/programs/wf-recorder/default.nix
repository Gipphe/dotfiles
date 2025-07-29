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
        cfg.package
        config.wayland.windowManager.hyprland.package
        coreutils
        ffmpeg
        gum
      ];
      text = ''
        set -l monitors (hyprctl monitors -j | jq --argjson nicknames '${builtins.toJSON cfg.nicknames}' 'map({ name: .name, description: .description, nickname: $nicknames[.description] })')
        set -l options (echo "$monitors" | jq '.[] | .nickname // .description')
        set -l selection (gum choose $options)
        set -l selected-monitor (echo "$monitors" | jq -r --arg selection "$selection" 'map(select((.nickname // .description) == $selection)) | .[] | .name')

        set -l filename "$(date +'%F %R:%S').mp4"
        set -l dest "$HOME/Videos/$filename"
        mkdir -p "$(dirname -- "$dest")"
        wf-recorder -f "$dest" -o "$selected-monitor"
      '';
    })
  ];
}
