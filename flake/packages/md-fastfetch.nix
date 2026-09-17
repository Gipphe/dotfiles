{
  writeNushellApplication,
  wezterm,
  hyprland,
  grim,
  fastfetch,
  unclutter,
  writeText,
}:
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
writeNushellApplication {
  name = "md:fastfetch";
  runtimeInputs = [
    wezterm
    hyprland
    grim
    fastfetch
    unclutter
  ];
  text = /* nu */ ''
    # Generate fastfetch output for the current host
    def main []: nothing -> nothing {
      let job_id = (job spawn { wezterm start --class neofetch --always-new-process -- bash -c 'sleep 1s && fastfetch --config "${cfg}" && read -p ""' })
      sleep 5sec

      let window = (hyprctl clients -j | from json | where class == "neofetch" | first)
      if $window == null {
        print -e "fastfetch did not spawn properly"
        job kill $job_id
        exit 1
      }

      let pos = ($"($window.at.0),($window.at.1)")
      # let dim = ($"($window.size.0)x($window.size.1)")
      let dim = "900x410"
      let g = $"($pos) ($dim)"

      # Hide the cursor with unclutter
      let unclutter_id = job spawn { unclutter -idle 0.1 -root }
      sleep 0.5sec

      mkdir assets/neofetch
      grim -g $g $"assets/neofetch/((sys host).hostname).png"

      job kill $job_id
      job kill $unclutter_id
    }
  '';
}
