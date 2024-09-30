{ lib, util, ... }:
util.mkToggledModule [ "machines" ] {
  name = "VNB-MB-Pro";

  shared.gipphe = {
    username = "victor";
    homeDirectory = "/Users/victor";
    hostName = "VNB-MB-Pro";
    profiles = {
      ai.enable = true;
      cli.enable = true;
      containers.enable = true;
      core.enable = true;
      darwin.enable = true;
      desktop.enable = true;
      k8s.enable = true;
      kvm.enable = true;
      logitech.enable = true;
      music.enable = true;
      rice-darwin.enable = true;
      rice.enable = true;
      secrets.enable = true;
      work.enable = true;
    };
  };

  system-all = {
    nix.settings.auto-optimise-store = lib.mkForce false;
  };
}
