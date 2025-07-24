{ util, config, ... }:
util.mkToggledModule [ "networking" ] {
  name = "lovdata-dns";
  hm = {
    programs.ssh.matchBlocks = {
      lovdata-stage = {
        host = "*.lovdata.c.bitbit.net";
        identitiesOnly = true;
        identityFile = [ config.sops.secrets.lovdata-ssh-key.path ];
        user = "vnb";
      };

      lovdata-stage-alias = {
        host = "stage";
        identitiesOnly = true;
        identityFile = [ config.sops.secrets.lovdata-ssh-key.path ];
        user = "vnb";
      };
    };
    sops.secrets.lovdata-ssh-key = {
      format = "binary";
      sopsFile = ../../../secrets/utv-vnb-lt-lovdata-stage.ssh;
      path = "${config.home.homeDirectory}/.ssh/lovdata.key";
    };
  };
  system-nixos = {
    networking = {
      search = [
        "lovdata.no"
        "lovdata.c.bitbit.net"
      ];
      extraHosts = ''
        stage02.lovdata.c.bitbit.net stage
      '';
    };
  };
}
