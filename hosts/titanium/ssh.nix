{ util, config, ... }:
util.mkModule {
  homeManager = {
    programs.ssh.settings."sodium.lan" = {
      hostname = "sodium.lan";
      user = "gipphe";
      identityFile = config.sops.secrets."titanium-sodium.ssh".path;
    };
    sops.secrets."titanium-sodium.ssh" = {
      format = "binary";
      sopsFile = ../../secrets/titanium-sodium.ssh;
    };
  };
}
