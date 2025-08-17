{ util, config, ... }:
util.mkProgram {
  name = "build-client";
  hm = {
    program.ssh = {
      matchBlocks = {
        builder = {
          # TODO replace hard-coded builder
          hostname = "titanium.lan";
          user = "builder";
          identitiesOnly = true;
          identityFile = config.sops.secrets."building-${config.gipphe.hostname}".path;
        };
      };
      userKnownHostsFile = "~/.ssh/known_hosts ${
        config.xdg.configFile."gipphe/builder-known-hosts".path
      }";
    };
    xdg.configFile."gipphe/builder-known-hosts".text = ''
      titanium.lan ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBal1aP8vSQqU3m0gVDYH8KxXns3H8+sfcJa7k7cMX95
    '';
    sops.secrets."argon-sshd.ssh.pub" = {
      format = "binary";
      sopsFile = ../../../secrets/argon-sshd.ssh.pub;
    };
  };
  system-droid = {
    nix.extraOptions = ''
      builders-use-substitutes = true
      builders = ssh://builder
    '';
  };
}
