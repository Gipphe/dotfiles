{ osConfig, lib }:
let
  # Gecko blocklists hardware video decoding on Nvidia/Linux, so the
  # force-enabled prefs below are only meaningful (and only tested) with
  # nvidia-vaapi-driver behind them.
  nvidiaHwDecode = osConfig.gipphe.hardware.gpu.nvidia.rtx3070.enable or false;

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
  }
  // lib.optionalAttrs nvidiaHwDecode {
    # Support additional video codecs
    media.hardware-video-decoding.force-enabled = true;
    gfx.x11-egl.force-enabled = true;
    widget.dmabuf.force-enabled = true;
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
