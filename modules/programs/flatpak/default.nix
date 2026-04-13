{ util, ... }:
util.mkProgram {
  name = "flatpak";
  system-nixos = {
    services.flatpak.enable = true;
    programs.bash.profileExtra = ''
      export XDG_DATA_DIRS=$XDG_DATA_DIRS:/usr/share:/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share
    '';
  };
}
