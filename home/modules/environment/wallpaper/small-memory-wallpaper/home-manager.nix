{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.gipphe.environment.wallpaper.small-memory.enable (
    lib.mkMerge [
      (lib.mkIf pkgs.stdenv.isLinux { stylix.image = ./wallpaper/Macchiato-hald8-wall.png; })
      (lib.mkIf pkgs.stdenv.isDarwin {
        home.activation = {
          set-wallpaper = ''
            run /usr/bin/automator -i "${./wallpaper/dynamic.heic}" "${./automator/set_desktop_wallpaper.workflow}"
          '';
        };
      })
    ]
  );
}
