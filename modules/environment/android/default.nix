{ util, ... }:
util.mkEnvironment {
  name = "android";
  nixOnDroid = {
    android-integration = {
      termux-open.enable = true;
      termux-open-url.enable = true;
      termux-setup-storage.enable = true;
      termux-reload-settings.enable = true;
      xdg-open.enable = true;
    };
  };
}
