{
  lib,
  flags,
  pkgs,
  ...
}:
let
  inherit (import ./paths.nix { inherit lib flags pkgs; }) darwinOptionsDir linuxOptionsDir;
  inherit (import ./plugins.nix { inherit lib flags pkgs; }) plugins;
  mkConfig = optionsDir: {
    "${optionsDir}/colors.scheme.xml".text = ''
      <application>
        <component name="EditorColorsManagerImpl">
          <global_color_scheme name="Catppuccin Macchiato" />
        </component>
      </application>
    '';
    "${optionsDir}/laf.xml".text = ''
      <application>
        <component name="LafManager">
          <laf themeId="com.github.catppuccin.macchiato.jetbrains" />
          <lafs-to-previous-schemes>
            <laf-to-scheme laf="ExperimentalDark" scheme="_@user_Catppuccin Macchiato" />
          </lafs-to-previous-schemes>
        </component>
      </application>
    '';
    "${optionsDir}/CatppuccinIcons.xml".text = ''
      <application>
        <component name="com.github.catppuccin.jetbrains_icons.settings.PluginSettingsState">
          <option name="variant" value="macchiato" />
        </component>
      </application>
    '';
    "${optionsDir}/editor-font.xml".text = ''
      <application>
        <component name="DefaultFont">
          <option name="VERSION" value="1" />
          <option name="FONT_FAMILY" value="FiraCode Nerd Font" />
          <option name="USE_LIGATURES" value="true" />
        </component>
      </application>
    '';
  };
  darwinConfig = lib.mkIf flags.system.isNixDarwin { home.file = mkConfig darwinOptionsDir; };
  linuxConfig = lib.mkIf (!flags.system.isNixDarwin) {
    xdg.dataFile = plugins;
    xdg.configFile = mkConfig linuxOptionsDir;
  };
in
lib.mkMerge [
  darwinConfig
  linuxConfig
]
