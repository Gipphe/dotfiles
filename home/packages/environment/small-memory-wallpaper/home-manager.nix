{ lib, config, ... }:
{
  config = lib.mkIf config.gipphe.environment.wallpaper.small-memory.enable (
    lib.mkMerge [
      (lib.mkIf lib.isLinux { stylix.image = ./wallpaper/Macchiato-hald8-wall.png; })
      (lib.mkIf lib.isDarwin {
        home.activation = {
          set-wallpaper = ''
            run /usr/bin/automator -i "${./wallpaper/dynamic.heic}" "${./automator/set_desktop_wallpaper.workflow}"
          '';
        };
      })
    ]
  );
}
