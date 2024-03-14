{ stdenv, ... }: {
  imports = [ ./home-jarle-wsl ./home-trond-arne ./strise-mb ];

  gpg-agent = {
    enable = !stdenv.isDarwin;
    defaultCacheTtl = 1800;
    grabKeyboardAndMouse = false;
    pinentryFlavor = "curses";
    # enableSshSupport = true;
  };
}
