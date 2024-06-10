{ lib, flags, ... }:
lib.optionalAttrs flags.system.isNixDarwin {
  xdg.configFile = {
    "linearmouse/linearmouse.json".source = ./linearmouse.json;
    "karabiner/karabiner.json".source = ./karabiner.json;
  };
  home.activation = {
    set-wallpaper = ''
      run /usr/bin/automator -i "${../../../theme/minimal_forest/dynamic.heic}" "${./automator/set_desktop_wallpaper.workflow}"
    '';
    import-alt-tab-config = ''
      run /usr/bin/defaults import com.lwouis.alt-tab-macos ${./alt-tab.xml}
    '';
  };
}
