{
  lib,
  config,
  util,
  pkgs,
  ...
}:
util.mkModule {
  options.gipphe.programs.wezterm.enable = lib.mkEnableOption "wezterm";
  hm = lib.mkIf config.gipphe.programs.wezterm.enable {
    programs.wezterm = {
      enable = true;
      extraConfig = # lua
        ''
          return {
            hide_tab_bar_if_only_one_tab = true,
            send_composed_key_when_left_alt_is_pressed = true,
            send_composed_key_when_right_alt_is_pressed = false,
            default_cursor_style = 'BlinkingBar',
            -- Disable easing for cursor, blinking text and visual bell
            animation_fps = 1,
          }
        '';
    };

    home.activation."copy-wezterm-config-to-repo" = lib.hm.dag.entryAfter [ "writeBoundary" ] (
      let
        inherit (util) copyFileFixingPaths mkCopyActivationScript;
        fromDir = "${config.xdg.configHome}/wezterm";
        toDir = "${config.home.homeDirectory}/projects/dotfiles/windows/Config/wezterm";
        fix-wezterm-config-paths =
          copyFileFixingPaths "fix-wezterm-config-paths" "${fromDir}/wezterm.lua"
            "${toDir}/wezterm.lua";
        copy-wezterm-config-dir = mkCopyActivationScript "copy-wezterm-config-dir" fromDir toDir;
        windowsConfig = # lua
          ''
            return {
              default_prog = { 'pwsh' },
            }
          '';
        createWindowsConfigSnippet =
          pkgs.writeText "createWindowsConfigSnippet" # lua
            ''
              local windows_wrapped_config()
                ${windowsConfig}
              end
            '';
        setWindowsConfigSnippet =
          pkgs.writeText "setWindowsConfigSnippet" # lua
            ''
              local windows_config = windows_wrapped_config()
              for key, value in pairs(windows_config) do
                  stylix_base_config[key] = value
              end
            '';
        tweak-wezterm-config = pkgs.writeShellApplication {
          name = "tweak-wezterm-config";
          runtimeInputs = [ pkgs.gnused ];
          runtimeEnv = {
            config = "${toDir}/wezterm.lua";
          };
          text = ''
            sed -i '/local function stylix_wrapped_config()/e cat ${createWindowsConfigSnippet}' -- "$config"
            sed -i '/return stylix_base_config/e cat ${setWindowsConfigSnippet}' -- "$config"
          '';
        };
        script = pkgs.writeShellApplication {
          name = "copy-wezterm-config";
          runtimeInputs = [
            fix-wezterm-config-paths
            copy-wezterm-config-dir
            tweak-wezterm-config
          ];
          text = ''
            copy-wezterm-config-dir
            fix-wezterm-config-paths
            tweak-wezterm-config
          '';
        };
      in
      "run ${script}/bin/copy-wezterm-config"
    );
  };
}
