{ util, ... }:
util.mkModule {
  hm = {
    imports = [ ./search-engines.nix ];
    programs.floorp.profiles.default = {
      settings = {
        "app.normandy.first_run" = false;
        # Scroll by pressing middle mouse and dragging
        "general.autoScroll" = true;
        # Show https prototol
        "browser.urlbar.trimHttps" = false;
        # Show url prototol and query params
        "browser.urlbar.trimURLs" = false;
        "taskbar.grouping.useprofile" = true;
        # Allow use of userChrome.css
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        # Disable kinetic/momentum/inertia when scrolling (especially bad
        # with touchpad)
        "apz.gtk.kinetic_scroll.enabled" = false;
        # Disable warning when entering about:config
        "browser.aboutConfig.showWarning" = false;
        # Disable AI chatbot in sidebar
        "browser.ai.control.sidebarChatBot" = "blocked";
        # Do not add default bookmarks to bookmarks menu
        "browser.bookmarks.restore_default_bookmarks" = false;
        "browser.bookmarks.showMobileBookmarks" = false;
        # Do not block content
        "browser.contentblocking.category" = "standard";
        # Show download panel when starting to download a file
        "browser.download.panel.shown" = true;
        # Use new sidebar
        "sidebar.revamp" = true;
        # Vertical tabs
        "sidebar.verticalTabs" = true;
        # Don't show suggestion to drag tabs to top of tab column to pin them
        "sidebar.verticalTabs.dragToPinPromo.dismissed" = true;
      };
    };
  };
}
