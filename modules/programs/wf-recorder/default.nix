{
  pkgs,
  lib,
  config,
  util,
  ...
}:
let
  cfg = config.gipphe.programs.wf-recorder;
  window_border = config.wayland.windowManager.hyprland.settings.general."col.active_border";
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
        jq
      ];
      text = ''
        set -l monitors (hyprctl monitors -j | jq --argjson nicknames '${builtins.toJSON cfg.nicknames}' 'map({ name: .name, description: .description, nickname: $nicknames[.description] })')
        or echo "Failed to get monitors" >&2 && exit 1

        set -l options (echo "$monitors" | jq -r '.[] | .nickname // .description')
        set -l selection (gum choose $options)
        or echo "Cancelled selection" >&2 && exit 1

        set -l selected_monitor (echo "$monitors" | jq -r --arg selection "$selection" 'map(select((.nickname // .description) == $selection)) | .[] | .name')

        set -l filename "$(date +'%F %R:%S').mp4"
        set -l dest "$HOME/Videos/$filename"
        mkdir -p "$(dirname -- "$dest")"
        hyprctl keyword 'general:col.active_border' "rgb(ff0000)"

        function final
          pkill wf-recorder
          clear -x
          hyprctl keyword 'general:col.active_border' "${window_border}"
          echo "Video saved to $dest"
        end

        trap final INT
        wf-recorder -f "$dest" -o "$selected_monitor"
        final
      '';
    })
  ];
}
