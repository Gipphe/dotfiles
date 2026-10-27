{
  lib,
  pkgs,
  util,
  config,
  ...
}:
util.mkProgram {
  name = "aerc";
  homeManager = {
    programs.aerc = {
      enable = true;
      extraConfig = {
        general.unsafe-accounts-conf = true;
        # Home Manager writes the whole aerc.conf, so aerc's shipped filters
        # don't apply and every viewable type has to be listed here. These are
        # all exact types, so the alphabetical order Nix emits is harmless --
        # but the first match wins, so any glob added here needs care.
        filters = {
          "text/plain" = "colorize";
          "text/calendar" = "calendar";
          "message/delivery-status" = "colorize";
          "message/rfc822" = "colorize";
          # '!' hands the terminal to the filter; the html one is already
          # wrapped with w3m by nixpkgs
          "text/html" =
            "! html -o display_link_number=true -o extbrowser=${lib.getExe' pkgs.xdg-utils "xdg-open"}";
          # Only used when viewer.show-headers is on
          ".headers" = "colorize";
        };
        viewer.pager = "${lib.getExe config.gipphe.programs.less.package}";
      };
    };
  };
}
