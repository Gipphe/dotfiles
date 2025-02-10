{ util, ... }:
util.mkToggledModule [ "machines" ] {
  name = "titanium";
  shared = {
    gipphe = {
      username = "Gipphe";
      homeDirectory = "C:/Users/Gipphe";
      hostName = "titanium";
      profiles = {
        ai.enable = true;
        cli.enable = true;
        containers.enable = true;
        core.enable = true;
        fonts.enable = true;
        game-dev.enable = false;
        gc.enable = true;
        programming.haskell.enable = true;
        rice.enable = true;
        secrets.enable = true;
        systemd.enable = true;
        vm-guest.enable = true;
        windows-setup.enable = true;
        work-slim.enable = true;
        work-wsl.enable = true;
      };
    };
  };
}
