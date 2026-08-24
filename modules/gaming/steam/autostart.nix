{ makeDesktopItem }:
makeDesktopItem {
  name = "steam-autostart";
  desktopName = "Steam";
  comment = "Application for managing and playing games on Steam";
  exec = "steam -silent %U";
  icon = "steam";
  terminal = false;
  type = "Application";
  prefersNonDefaultGPU = true;
  categories = [
    "Network"
    "FileTransfer"
    "Game"
  ];
  mimeTypes = [
    "x-scheme-handler/steam"
    "x-scheme-handler/steamlink"
  ];
  actions = {
    act-1 = {
      name = "Store";
      exec = "steam steam://store";
    };
    act-2 = {
      name = "Community";
      exec = "steam steam://url/CommunityHome/";
    };
    act-3 = {
      name = "Library";
      exec = "steam steam://open/games";
    };
    act-4 = {
      name = "Servers";
      exec = "steam steam://open/servers";
    };
    act-5 = {
      name = "Screenshots";
      exec = "steam://open/screenshots";
    };
    act-6 = {
      name = "News";
      exec = "steam://openurl/https://store.steampowered.com/news";
    };
    act-7 = {
      name = "Settings";
      exec = "steam steam://open/settings";
    };
    act-8 = {
      name = "BigPicture";
      exec = "steam steam://open/bigpicture";
    };
    act-9 = {
      name = "Friends";
      exec = "steam steam://open/friends";
    };
  };
}
