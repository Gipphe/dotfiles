{
  lib,
  config,
  flags,
  ...
}:
{
  config = lib.mkIf config.gipphe.environment.wallpaper.small-memory.enable (
    lib.mkMerge [
      (lib.mkIf flags.system.isNixos { stylix.image = ./wallpaper/Macchiato-hald8-wall.png; })
      (lib.mkIf flags.system.isNixDarwin {
        home.activation = {
          set-wallpaper = ''
            run /usr/bin/automator -i "${./wallpaper/dynamic.heic}" "${./automator/set_desktop_wallpaper.workflow}"
          '';
        };
      })
    ]
  );
}
