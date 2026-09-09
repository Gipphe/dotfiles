{ lib }:
let
  prefs = {
    "extensions.autoDisableScopes" = 0;
    "extensions.pocket.enabled" = false;
    # Scroll by pressing middle mouse and dragging
    "general.autoScroll" = true;
    # Show https prototol
    "browser.urlbar.trimHttps" = false;
    # Show url prototol and query params
    "browser.urlbar.trimURLs" = false;
    # "taskbar.grouping.useprofile" = true;
    # Allow use of userChrome.css
    "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
    # Disable kinetic/momentum/inertia when scrolling (especially bad
    # with touchpad)
    "apz.gtk.kinetic_scroll.enabled" = false;
    # Disable warning when entering about:config
    "browser.aboutConfig.showWarning" = false;
    # Show more ssl cert infos
    "security.identityblock.show_extended_validation" = true;
  };

in
lib.concatLines (
  lib.mapAttrsToList (
    name: value: "lockPref(${lib.strings.toJSON name}, ${lib.strings.toJSON value});"
  ) prefs
)
