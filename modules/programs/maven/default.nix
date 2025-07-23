{
  util,
  pkgs,
  config,
  ...
}:
util.mkProgram {
  name = "maven";
  hm = {
    home = {
      packages = [
        pkgs.maven
      ];
      file.".m2/settings-security.xml".text = ''
        <settingsSecurity>
          <relocation>
            ${config.sops.secrets.lovdata-maven-settings-security.path}
          </relocation>
        </settingsSecurity>
      '';
    };
    sops.secrets.lovdata-maven-settings-security = {
      format = "binary";
      sopsFile = ../../../secrets/utv-vnb-lt-maven-settings-security.xml;
    };
  };
}
