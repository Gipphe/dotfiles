{
  util,
  pkgs,
  config,
  ...
}:
util.mkProgram {
  name = "maven";
  hm = {
    home.packages = [ pkgs.maven ];
    sops.secrets.lovdata-maven-settings-security = {
      format = "binary";
      sopsFile = ../../../secrets/utv-vnb-lt-maven-settings-security.xml;
      path = "${config.home.homeDirectory}/projects/lovdata/settings-security.xml";
      mode = "0400";
    };
  };
}
