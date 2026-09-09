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

    # uBlock Origin
    (extension "ublock-origin" "uBlock0@raymondhill.net")
    # 1Password
    (extension "1password-x-password-manager" "{d634138d-c276-4fc8-924b-40a0ea21d284}")
    # DeArrow
    (extension "dearrow" "deArrow@ajay.app")
    # 'Improve YouTube!' 🎧 (For YouTube & Video)
    (extension "youtube-addon" "{3c6bf0cc-3ae2-42fb-9993-0d33104fdcaf}")
    # Facebook Container
    (extension "facebook-container" "@contain-facebook")
    # Privacy Badger
    (extension "privacy-badger17" "jid1-MnnxcxisBPnSXQ@jetpack")
    # Reddit Enhancement Suite
    (extension "reddit-enhancement-suite" "jid1-xUfzOsOFlzSOXg@jetpack")
    # SponsorBlock
    (extension "sponsorblock" "sponsorBlocker@ajay.app")
    # Tridactyl
    (extension "tridactyl-vim" "tridactyl.vim@cmcaine.co.uk")
  ];
in
builtins.listToAttrs extensions
