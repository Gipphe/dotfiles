{
  lib,
  flags,
  pkgs,
  ...
}:
let
  inherit (lib) hasSuffix pipe mapAttrsToList;
  inherit (pkgs) fetchzip stdenv;
  inherit (lib.strings) getVersion;
  inherit (lib.versions) majorMinor;
  inherit (builtins) fetchurl listToAttrs;
  rawPlugins = {
    "1347-scala" = {
      name = "Scala";
      url = "https://plugins.jetbrains.com/files/1347/544339/scala-intellij-bin-2024.1.21.zip";
      hash = "sha256-6ibo1vdwO4olQTCWpWAefT3QCwgtzTo1ojilDes8Rvg=";
    };
    "164-ideavim" = {
      name = "IdeaVim";
      url = "https://plugins.jetbrains.com/files/164/546759/IdeaVim-2.12.0-signed.zip";
      hash = "sha256-X7gAfpzhnTOsz3z170ahZ1ddqMHND8+qMzoXU51R/S4=";
    };
    "18682-catppuccin-theme" = {
      name = "Catppuccin Theme";
      url = "https://plugins.jetbrains.com/files/18682/546280/Catppuccin_Theme-3.3.1.zip";
      hash = "sha256-Mm3V0mlW59EJyCzr75dhKFsOfUPnsVnU+D26+sFAnQ4=";
    };
    "23029-catppuccin-icons" = {
      name = "Catppuccin Icons";
      url = "https://plugins.jetbrains.com/files/23029/542152/Catppuccin_Icons-1.5.0.zip";
      hash = "sha256-AlxMNYxS84BvQalaj3o14zHEXONuRNE5EOaJO7kNqAQ=";
    };
    "12062-vscode-keymap" = {
      name = "VSCode Keymap";
      url = "https://plugins.jetbrains.com/files/12062/508223/keymap-vscode-241.14494.150.zip";
      hash = "sha256-LeQ5vi9PCJYmWNmT/sutWjSlwZaAYYuEljVJBYG2VpY=";
    };
  };

  configDir =
    let
      name = pkgs.jetbrains.idea-ultimate.name;
      _name = "IntelliJIdea";
      _version = majorMinor (getVersion name);
    in
    "JetBrains/${_name}${_version}";
  altPlugins = pipe rawPlugins [
    (mapAttrsToList (key: val: mkAltPlugin key val))
    listToAttrs
  ];
  mkAltPlugin = id: plugin: {
    name = "${configDir}/${plugin.name}";
    value.source = mkPlugin id plugin;
  };

  fetchPluginSrc =
    url: hash:
    let
      isJar = hasSuffix ".jar" url;
      fetcher = if isJar then fetchurl else fetchzip;
    in
    fetcher {
      executable = isJar;
      inherit url hash;
    };

  mkPlugin =
    id: file:
    stdenv.mkDerivation {
      name = "jetbrains-plugin-${id}";
      installPhase = ''
        runHook preInstall
        mkdir -p $out && cp -r . $out
        runHook postInstall
      '';
      src = fetchPluginSrc file.url file.hash;
    };
in
lib.optionalAttrs (!flags.system.isNixDarwin) {
  home = {
    packages = with pkgs; [ jetbrains.idea-ultimate ];
    file.".ideavimrc".text = ''
      set number
      set relativenumber
    '';
  };
  xdg.dataFile = altPlugins;
  xdg.configFile = {
    "JetBrains/${configDir}/options/colors.scheme.xml".text = ''
      <application>
        <component name="EditorColorsManagerImpl">
          <global_color_scheme name="Catppuccin Macchiato" />
        </component>
      </application>
    '';
    "JetBrains/${configDir}/options/laf.xml".text = ''
      <application>
        <component name="LafManager">
          <laf themeId="com.github.catppuccin.macchiato.jetbrains" />
          <lafs-to-previous-schemes>
            <laf-to-scheme laf="ExperimentalDark" scheme="_@user_Catppuccin Macchiato" />
          </lafs-to-previous-schemes>
        </component>
      </application>
    '';
    "JetBrains/${configDir}/options/CatppuccinIcons.xml".text = ''
      <application>
        <component name="com.github.catppuccin.jetbrains_icons.settings.PluginSettingsState">
          <option name="variant" value="macchiato" />
        </component>
      </application>
    '';
    "JetBrains/${configDir}/options/editor-font.xml".text = ''
      <application>
        <component name="DefaultFont">
          <option name="VERSION" value="1" />
          <option name="FONT_FAMILY" value="FiraCode Nerd Font" />
          <option name="USE_LIGATURES" value="true" />
        </component>
      </application>
    '';
  };
  programs.fish.shellAbbrs.idea = "idea-ultimate";
}
