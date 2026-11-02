{ lib, ... }:
{
  den.aspects.programs.floorp = {
    settings.default = lib.mkEnableOption "Floorp as default browser";
    homeManager =
      { user }:
      { config, pkgs, ... }:
      let
        pkg = config.programs.floorp.finalPackage or config.programs.floorp.package or pkgs.floorp;

        base = {
          programs.floorp = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
            enable = true;
            nativeMessagingHosts = [ pkgs.tridactyl-native ];
            policies = {
              DisableTelemetry = true;
              DNSOverHTTPS = {
                ProviderURL = "https://dns.quad9.net/dns-query";
                Fallback = false;
              };
              OfferToSaveLogins = false;
              PasswordManagerEnabled = false;
            };
          };
          stylix.targets.floorp.profileNames = [ "default" ];
        };

        defaultConf = {
          home.sessionVariables = {
            BROWSER = lib.getExe' pkg "floorp";
            DEFAULT_BROWSER = lib.getExe' pkg "floorp";
          };
          gipphe.core.wm.bind."SUPER + B".action.spawn = lib.getExe' pkg "floorp";
          xdg.mimeApps.defaultApplicationPackages = [ pkg ];
        };
      in
      {
        config = lib.mkMerge [
          base
          (lib.mkIf user.settings.programs.floorp.default defaultConf)
        ];
      };
  };
}
