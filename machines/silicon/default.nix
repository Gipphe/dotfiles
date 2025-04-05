{ lib, util, ... }:
util.mkToggledModule [ "machines" ] {
  name = "silicon";

  shared.gipphe = {
    username = "victor";
    homeDirectory = "/Users/victor";
    hostName = "silicon";
    profiles = {
      ai.enable = true;
      cli.enable = true;
      containers.enable = true;
      core.enable = true;
      darwin.enable = true;
      desktop.enable = true;
      game-dev.enable = true;
      home-vpn.enable = true;
      k8s.enable = true;
      kvm.enable = true;
      logitech.enable = true;
      music.enable = true;
      rice-darwin.enable = true;
      rice.enable = true;
      secrets.enable = true;
      windows-setup.enable = true;
      work.enable = true;
    };
  };

  system-darwin = {
    nix.settings.auto-optimise-store = lib.mkForce false;
  };
}
