{ lib, ... }: {
  den.aspects.programs.yazi = {
    settings.default = lib.mkEnableOption "yazi as default file manager";
    homeManager =
      { user }:
      { config, pkgs, ... }:
      let
        file_manager_script = pkgs.writeShellScript "file-manager-script.sh" ''
          ${config.programs.wezterm.package}/bin/wezterm start -- "${config.programs.yazi.package}/bin/yazi"
        '';
      in
      {
        programs.yazi = {
          enable = true;
          shellWrapperName = "y";
        };
        gipphe.core.wm.bind = lib.mkIf user.settings.programs.yazi.default {
          "SUPER + E".action.spawn = "${file_manager_script}";
        };
      };
  };
}
