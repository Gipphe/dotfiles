{ lib, pkgs, ... }:
{
  config = lib.mkIf pkgs.stdenv.isLinux {
    services.gpg-agent = {
      enable = true;
      defaultCacheTtl = 1800;
      grabKeyboardAndMouse = false;
      pinentryPackage = pkgs.pinentry-curses;
      # enableSshSupport = true;
    };
  };
}
