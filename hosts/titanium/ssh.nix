{ util, config, ... }:
util.mkModule {
  homeManager = {
    programs.ssh.settings."sodium.lan" = {
      hostname = "sodium.lan";
      user = "gipphe";
      identityFile = config.sensitive.secrets.secrets."titanium/sodium.ssh";
    };
  };
}
