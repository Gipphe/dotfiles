{ config, ... }:
{
  config.services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    grabKeyboardAndMouse = false;
    pinentryFlavor = "curses";
    # enableSshSupport = true;
  };
}
