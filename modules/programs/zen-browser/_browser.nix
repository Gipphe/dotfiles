{ name, iconColor }:
{ inputs, ... }:
let
  # zen-browser-unwrapped only sets the (now unused) `ffmpegSupport`
  # passthru attr, but nixpkgs' wrapFirefox reads `withFFmpeg`. Without
  # this, libavcodec is never added to LD_LIBRARY_PATH, so H264/AAC/HEVC
  # can't be decoded at all, not even in software.
  mkBrowser =
    { pkgs }:
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.zen-browser-unwrapped.overrideAttrs
      (old: {
        passthru = (old.passthru or { }) // {
          withFFmpeg = true;
        };
      });

  mkWrapped =
    {
      pkgs,
      config,
      lib,
      osConfig,
    }:
    let
      browser = mkBrowser { inherit pkgs; };
    in
    pkgs.wrapFirefox browser {
      pname = "${browser.pname}-${name}";
      appDataDir = "${config.xdg.configHome}/zen-${name}";

      extraPrefs = import ./_preferences.nix { inherit lib osConfig; };

      # See docs for policies here: https://mozilla.github.io/policy-templates/
      extraPolicies = {
        DisableTelemetry = true;
        DisablePocket = true;
        DisableFirefoxStudies = true;
        DisableFirefoxAccounts = false; # Allow sync
        ExtensionSettings = import ./_extensions.nix;
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
        SearchEngines = import ./_search-engines.nix;
      };
    };
  binaryName = "zen-${name}";
  mkPkg =
    {
      pkgs,
      lib,
      osConfig,
      config,
    }:
    let
      browser = mkBrowser { inherit pkgs; };
      wrapped = mkWrapped {
        inherit
          pkgs
          lib
          osConfig
          config
          ;
      };
    in
    pkgs.symlinkJoin {
      pname = binaryName;
      version = browser.version;
      paths = [ wrapped ];
      buildInputs = [
        pkgs.makeWrapper
        pkgs.imagemagick
      ];

      postBuild = ''
        mv "$out/bin/${wrapped.meta.mainProgram}" "$out/bin/${binaryName}"
        cp -L "$out/share/applications/zen.desktop" "./${binaryName}.desktop"
        substituteInPlace "./${binaryName}.desktop" \
          --replace-fail 'zen --name zen %U' '${binaryName} --name ${binaryName} %U' \
          --replace-fail 'zen --private-window %U' '${binaryName} --private-window %U' \
          --replace-fail 'zen --new-window %U' '${binaryName} --new-window %U' \
          --replace-fail 'zen --ProfileManager' '${binaryName} --ProfileManager' \
          --replace-fail 'Name=Zen Browser' 'Name=Zen ${name}' \
          --replace-fail 'Icon=zen' 'Icon=${binaryName}' \
          --replace-fail 'StartupWMClass=zen' 'StartupWMClass=${binaryName}'
        rm -f "$out/share/applications/zen.desktop"
        mv "./${binaryName}.desktop" "$out/share/applications/${binaryName}.desktop"

        for icon in $out/share/icons/hicolor/*/apps/zen.png; do
          dir="$(dirname "$icon")"
          magick "$icon" -fill "${iconColor}" -colorize 55% "$dir/${binaryName}.png"
          rm -f "$icon"
        done
      '';

      meta = wrapped.meta // {
        mainProgram = binaryName;
      };
    };
in
{
  den.aspects.programs.zen-browser.${name} = {
    homeManager =
      {
        config,
        lib,
        pkgs,
        osConfig,
        ...
      }:
      let
        pkg = mkPkg {
          inherit
            config
            osConfig
            pkgs
            lib
            ;
        };
      in
      {
        home.packages = [ pkg ];
      };
    nixos.environment.etc."1password/custom_allowed_browsers".text = ''
      zen-${name}
    '';

    default.homeManager =
      {
        lib,
        config,
        osConfig,
        pkgs,
        ...
      }:
      let
        pkg = mkPkg {
          inherit
            config
            osConfig
            pkgs
            lib
            ;
        };
      in
      {
        home.sessionVariables = {
          BROWSER = lib.getExe pkg;
          DEFAULT_BROWSER = lib.getExe pkg;
        };
        gipphe.core.wm.bind."SUPER + B".action.spawn = "${lib.getExe pkg} --name ${binaryName}";
        xdg.mimeApps.defaultApplicationPackages = [ pkg ];
      };
  };
}
