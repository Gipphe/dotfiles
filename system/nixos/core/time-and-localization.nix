let
  tz = "Europe/Oslo";
in
{
  time = {
    # Set your time zone.
    timeZone = tz;
    hardwareClockInLocalTime = true;
  };
  environment.sessionVariables.TZ = tz;

  i18n =
    let
      defaultLocale = "en_US.UTF-8";
      no = "nb_NO.UTF-8";
    in
    {
      inherit defaultLocale;
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
}
