name:
{
  config,
  lib,
  pkgs,
  inputs,
  util,
  ...
}:
let
  cfg = config.gipphe.programs.zen-browser.${name};

  browser = inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.zen-browser-unwrapped;
  wrapped = pkgs.wrapFirefox browser {
    pname = "${browser.pname}-${name}";
    appDataDir = "${config.xdg.configHome}/zen-${name}";

    extraPrefs = import ./preferences.nix { inherit lib; };

    # See docs for policies here: https://mozilla.github.io/policy-templates/
    extraPolicies = {
      DisableTelemetry = true;
      DisablePocket = true;
      DisableFirefoxStudies = true;
      DisableFirefoxAccounts = true;
      ExtensionSettings = import ./extensions.nix;
      DontCheckDefaultBrowser = true;
      AIControls.Default = "blocked";
      GenerativeAI.Enabled = false;
      HttpsOnlyMode = "force_enabled";
      NetworkPrediction = true;
      NoDefaultBookmarks = true;
      DNSOverHTTPS = {
        Enabled = true;
        ProviderURL = "https://dns.quad9.net/dns-query";
        Locked = true;
        ExcludedDomains = [ ];
        Fallback = false;
      };
      SearchEngines = import ./search-engines.nix { inherit pkgs; };
    };
  };
  binaryName = "zen-${name}";
  pkg = pkgs.symlinkJoin {
    pname = binaryName;
    version = browser.version;
    paths = [ wrapped ];
    buildInputs = [ pkgs.makeWrapper ];

    postBuild = ''
      mv "$out/bin/${wrapped.meta.mainProgram}" "$out/bin/${binaryName}"
      cp -L "$out/share/applications/zen.desktop" "./${binaryName}.desktop"
      substituteInPlace "./${binaryName}.desktop" \
        --replace-fail 'zen --name zen %U' '${binaryName} --name ${binaryName} %U' \
        --replace-fail 'zen --private-window %U' '${binaryName} --private-windoe %U' \
        --replace-fail 'zen --new-window %U' '${binaryName} --new-window %U' \
        --replace-fail 'zen --ProfileManager' '${binaryName} --ProfileManager' \
        --replace-fail 'Name=Zen Browser' 'Name=Zen ${name}'
      rm -f "$out/share/applications/zen.desktop"
      mv "./${binaryName}.desktop" "$out/share/applications/${binaryName}.desktop"
    '';

    meta = wrapped.meta // {
      mainProgram = binaryName;
    };
  };
in
util.mkToggledModule [ "programs" "zen-browser" ] {
  inherit name;
  options.gipphe.programs.zen-browser.${name} = {
    default = lib.mkEnableOption "Zen ${name} as default browser";
  };
  homeManager.config = lib.mkMerge [
    {
      home.packages = [ pkg ];
    }

    (lib.mkIf cfg.default {
      home.sessionVariables = {
        BROWSER = lib.getExe pkg;
        DEFAULT_BROWSER = lib.getExe pkg;
      };
      gipphe.core.wm.bind = lib.mkIf cfg.default {
        "SUPER + B".action.spawn = lib.getExe pkg;
      };
      xdg.mimeApps.defaultApplicationPackages = [ pkg ];
    })
  ];
  nixos.environment.etc."1password/custom_allowed_browsers".text = ''
    zen-${name}
  '';
}
