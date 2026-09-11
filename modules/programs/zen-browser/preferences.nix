{ lib }:
let
  prefs = {
    extensions.autoDisableScopes = 0;
    extensions.pocket.enabled = false;
    # Scroll by pressing middle mouse and dragging
    general.autoScroll = true;
    # Allow use of userChrome.css
    toolkit.legacyUserProfileCustomizations.stylesheets = true;
    # Disable kinetic/momentum/inertia when scrolling (especially bad
    # with touchpad)
    apz.gtk.kinetic_scroll.enabled = false;
    # Show more ssl cert infos
    security.identityblock.show_extended_validation = true;
    # Disable warning when entering about:config
    browser.aboutConfig.showWarning = false;
    # Tab groups
    browser.tabs.groups.enabled = true;
  };

  flattenKey = { name, value }: {
    name = builtins.concatStringsSep "." name;
    inherit value;
  };
  flattenAttrsToList =
    key: val:
    if builtins.isAttrs val then
      lib.concatMap (name: flattenAttrsToList (key ++ [ name ]) val.${name}) (builtins.attrNames val)
    else
      [ (lib.nameValuePair key val) ];
  toLockPref = { name, value }: "lockPref(${lib.strings.toJSON name}, ${lib.strings.toJSON value});";
in
lib.pipe prefs [
  (flattenAttrsToList [ ])
  (map flattenKey)
  (map toLockPref)
  lib.concatLines
]
