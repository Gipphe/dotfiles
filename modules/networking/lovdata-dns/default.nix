{ util, ... }:
util.mkToggledModule [ "networking" ] {
  name = "lovdata-dns";
  hm.sops.secrets.lovdata-ssh-key = {
    format = "binary";
    sopsFile = ../../../secrets/utv-vnb-lt-lovdata-stage.ssh;
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
