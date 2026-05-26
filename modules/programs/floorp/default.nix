{
  config,
  util,
  lib,
  pkgs,
  flags,
  ...
}:
let
  cfg = config.gipphe.programs.floorp;
  pkg = config.programs.floorp.finalPackage or config.programs.floorp.package or pkgs.floorp;

  base = {
    programs.floorp = lib.mkIf (pkgs.stdenv.hostPlatform.isLinux && !flags.isNixOnDroid) {
      enable = true;
      nativeMessagingHosts = [ pkgs.tridactyl-native ];
      policies = {
        DisableTelemetry = true;
        DNSOverHTTPS = {
          ProviderURL = "https://dns.mullvad.net/dns-query";
          Fallback = false;
        };
        OfferToSaveLogins = false;
        PasswordManagerEnabled = false;
      };
    };
    stylix.targets.floorp.profileNames = [ "default" ];
  };

  defaultConf = lib.mkIf cfg.default {
    home.sessionVariables = {
      BROWSER = lib.getExe' pkg "floorp";
      DEFAULT_BROWSER = lib.getExe' pkg "floorp";
    };
    gipphe.core.wm.binds = lib.mkIf cfg.default [
      {
        mod = "Mod";
        key = "B";
        action.spawn = lib.getExe' pkg "floorp";
      }
    ];
    xdg.mimeApps.defaultApplicationPackages = [ pkg ];
  };

in
util.mkProgram {
  name = "floorp";
  options.gipphe.programs.floorp = {
    default = lib.mkEnableOption "Floorp as default browser" // {
      default = true;
    };
  };
  homeManager = {
    imports = [
      ./extensions.nix
      ./profile
    ];
    config = lib.mkMerge [
      base
      defaultConf
    ];
  };
}
