{ util, ... }:
util.mkNestedProfile [ "windows" "core" ] {
  windows = {
    chocolatey = {
      enable = true;
      programs = [
        "7zip"
        "firacodenf"
        "irfanview"
        "irfanview-languages"
        "irfanviewplugins"
        "nvidia-app"
        "lghub"
        "microsoft-windows-terminal"
        "msiafterburner"
        "nvidia-broadcast"
        "powershell-core"
        "powertoys"
        "sumatrapdf"
        "vcredist-all"
        "voicemeeter"
        "wezterm"
        "windhawk"
      ];
    };

    scoop = {
      enable = true;
      buckets = [ "extras" ];
    };
  };
}
