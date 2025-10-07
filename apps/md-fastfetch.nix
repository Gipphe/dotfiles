{
  lib,
  writeFishApplication,
  wezterm,
  coreutils,
  hyprland,
  grim,
  fastfetch,
  unclutter,
  writeText,
}:
{
  type = "app";
  program =
    let
      help = "Generate fastfetch output for the current host";
      name = "md:fastfetch";
      script = writeFishApplication {
        inherit name;
        runtimeInputs = [
          wezterm
          coreutils
          hyprland
          grim
          fastfetch
          unclutter
        ];
        text =
          let
            cfg = writeText "fastfetch-config" (
              builtins.toJSON {
                "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";
                modules = [
                  "title"
                  "separator"
                  "os"
                  "host"
                  "kernel"
                  # "uptime"
                  "packages"
                  "shell"
                  "display"
                  "de"
                  "wm"
                  "wmtheme"
                  "theme"
                  "icons"
                  "font"
                  "cursor"
                  "terminal"
                  "terminalfont"
                  "cpu"
                  "gpu"
                  "memory"
                  "swap"
                  "disk"
                  # "localip"
                  "battery"
                  "poweradapter"
                  "locale"
                  "break"
                  "colors"
                ];
              }
            );
          in
          # fish
          ''
            function info
              echo "$args" > &2
            end

            if contains "--help" $args || contains "-h" $args
              info "${name} - ${help}"
              exit 0
            end

            wezterm start --class neofetch --always-new-process -- bash -c 'sleep 1s && fastfetch --config "${cfg}" && read -p ""' &
            sleep 5s

            set -l window (hyprctl clients -j | jq -r '.[] | select(.class == "neofetch")')

            set -l window_pid (echo $window | jq '.pid')
            set -l pos (echo $window | jq -r '.at | (.[0] | tostring) + "," + (.[1] | . + 8 | tostring)')
            # set -l dim (echo $window | jq -r '.size | (.[0] | tostring) + "x" + (.[1] | tostring)')
            set -l dim "900x410"
            set -l g "$pos $dim"

            # Hide the cursor with unclutter
            unclutter -idle 0.1 -root &
            set -l unclutter_pid (jobs --last --pid | tail -n +1)
            sleep 0.5s

            mkdir -p assets/neofetch
            grim -g "$g" "assets/neofetch/$(hostname).png"

            kill $window_pid
            kill $unclutter_pid
          '';
      };
    in
    lib.getExe script;
}
