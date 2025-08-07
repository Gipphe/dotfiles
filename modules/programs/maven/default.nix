{
  lib,
  util,
  pkgs,
  config,
  ...
}:
let
  cfg = config.gipphe.programs.maven;
in
util.mkProgram {
  name = "maven";
  options.gipphe.programs.maven.lovdata.enable = lib.mkEnableOption "Lovdata integration";
  hm.config = lib.mkMerge [
    {
      home = {
        packages = [
          pkgs.maven
        ];
      };
    }
    (lib.mkIf cfg.lovdata.enable {
      home.file.".m2/settings-security.xml".text = ''
        <settingsSecurity>
          <relocation>
            ${config.sops.secrets.lovdata-maven-settings-security.path}
          </relocation>
        </settingsSecurity>
      '';
      sops.secrets.lovdata-maven-settings-security = {
        format = "binary";
        sopsFile = ../../../secrets/utv-vnb-lt-maven-settings-security.xml;
      };
    })
  ];
}
