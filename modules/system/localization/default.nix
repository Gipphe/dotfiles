{ util, ... }:
let
  defaultLocale = "en_US.UTF-8";
  no = "nb_NO.UTF-8";
in
util.mkToggledModule [ "system" ] {
  name = "localization";
  system-nixos = {
    i18n = {
      defaultLocale = no;
      extraLocaleSettings = {
        LANG = defaultLocale;
        LC_COLLATE = defaultLocale;
        LC_CTYPE = defaultLocale;
        LC_MESSAGES = defaultLocale;

        LC_ADDRESS = no;
        LC_IDENTIFICATION = no;
        LC_MEASUREMENT = no;
        LC_MONETARY = no;
        LC_NAME = no;
        LC_NUMERIC = no;
        LC_PAPER = no;
        LC_TELEPHONE = no;
        LC_TIME = no;
      };
    };
  };
}
