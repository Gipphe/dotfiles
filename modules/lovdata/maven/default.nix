{
  util,
  config,
  inputs,
  ...
}:
util.mkToggledModule [ "lovdata" ] {
  name = "maven";
  hm = {
    imports = [ inputs.lovdata.homeModules.maven ];
    config = {
      lovdata.maven = {
        enable = true;
        secureSettings = {
          masterPasswordFilePath = config.sops.secrets.lovdata-maven-settings-security.path;
          encryptedNexusPassword = "{SW1UCojanZEHfUU9n8tS0NvCTIQEaRSynWDF8ljWPm4=}";
        };
      };
      sops.secrets.lovdata-maven-settings-security = {
        format = "binary";
        sopsFile = ../../../secrets/utv-vnb-lt-maven-settings-security.xml;
      };
    };
  };
}
