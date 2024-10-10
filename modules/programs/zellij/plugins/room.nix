{
  config,
  pkgs,
  ...
}:
let
  room = pkgs.fetchurl {
    url = "https://github.com/rvcas/room/releases/download/v1.1.1/room.wasm";
    hash = "sha256-wCGnvFaoaoyH6QFkIqaDj0j0lGe1DOAX4ZmUQOyT/eY=";
  };
  inherit (config.gipphe.lib.zellij) bind shared_except;
in
{
  xdg.configFile."zellij/plugins/room.wasm".source = room;
  programs.zellij.settings.keybinds = shared_except [ "locked" ] (
    bind "Ctrl o" {
      "LaunchOrFocusPlugin \"file:~/.config/zellij/plugins/room.wasm\"" = {
        floating = true;
        ignore_case = true;
        quick_jump = true;
      };
    }
  );
}
