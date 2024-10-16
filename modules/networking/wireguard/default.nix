{ util, ... }:
util.mkToggledModule [ "networking" ] {
  name = "wireguard";
  system-darwin.homebrew.masApps.Wireguard = 1451685025;
}
