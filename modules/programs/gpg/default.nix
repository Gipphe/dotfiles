{ pkgs, util, ... }:
util.mkProgram {
  name = "gpg";

  hm = {
    programs.gpg.enable = true;
    services.gpg-agent = {
      enable = true;
      defaultCacheTtl = 1800;
      grabKeyboardAndMouse = false;
      pinentry.package = pkgs.pinentry-curses;
    };
  };

  system-nixos.programs.gnupg.agent.enable = true;
}
