let
  extension = shortId: guid: {
    name = guid;
    value = {
      install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
      installation_mode = "normal_installed";
    };
  };
  extensions = [
    # To add additional extensions, find it on addons.mozilla.org, find
    # the short ID in the url (like https://addons.mozilla.org/en-US/firefox/addon/!SHORT_ID!/)
    # Then go to https://addons.mozilla.org/api/v5/addons/addon/!SHORT_ID!/ to get the guid

    # 1Password
    (extension "1password-x-password-manager" "{d634138d-c276-4fc8-924b-40a0ea21d284}")
    # DeArrow
    (extension "dearrow" "deArrow@ajay.app")
    # 'Improve YouTube!' 🎧 (For YouTube & Video)
    (extension "youtube-addon" "{3c6bf0cc-3ae2-42fb-9993-0d33104fdcaf}")
    # Facebook Container
    (extension "facebook-container" "@contain-facebook")
    # Firefox Color
    (extension "firefox-color" "FirefoxColor@mozilla.com")
    # Firefox Multi-Account Containers
    (extension "multi-account-containers" "@testpilot-containers")
    # Privacy Badger
    (extension "privacy-badger17" "jid1-MnnxcxisBPnSXQ@jetpack")
    # Reddit Enhancement Suite
    (extension "reddit-enhancement-suite" "jid1-xUfzOsOFlzSOXg@jetpack")
    # SponsorBlock
    (extension "sponsorblock" "sponsorBlocker@ajay.app")
    # Tab Session Manager
    (extension "tab-session-manager" "Tab-Session-Manager@sienori")
    # Tridactyl
    (extension "tridactyl-vim" "tridactyl.vim@cmcaine.co.uk")
    # User-Agent Switcher
    (extension "uaswitcher" "user-agent-switcher@ninetailed.ninja")
  ];
in
builtins.listToAttrs extensions
