{
  util,
  inputs,
  config,
  ...
}:
util.mkToggledModule [ "lovdata" ] {
  name = "ssh";
  hm = {
    imports = [ inputs.lovdata.homeModules.ssh ];

    lovdata.ssh = {
      enable = true;
      servers = {
        gitlab.keyPath = config.sops.secrets.lovdata-gitlab-ssh-key.path;
        stage = {
          username = "vnb";
          keyPath = config.sops.secrets.lovdata-stage-ssh-key.path;
        };
      };
    };

    sops.secrets = {
      lovdata-gitlab-ssh-key = {
        format = "binary";
        mode = "400";
        sopsFile = ../../../secrets/${config.gipphe.hostName}-lovdata-gitlab.ssh;
      };

      lovdata-stage-ssh-key = {
        format = "binary";
        sopsFile = ../../../secrets/utv-vnb-lt-lovdata-stage.ssh;
      };
    };
  };
}
