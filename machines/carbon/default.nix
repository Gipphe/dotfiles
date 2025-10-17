{
  lib,
  config,
  util,
  ...
}:
let
  host = import ./host.nix;
in
util.mkToggledModule [ "machines" ] {
  inherit (host) name;
  shared = {
    gipphe = {
      username = "nix-on-droid";
      homeDirectory = "/data/data/com.termux.nix/files/home";
      hostName = host.name;
      profiles = {
        android.enable = true;
        cli-slim.enable = true;
        core.enable = true;
        fonts.enable = true;
        gc.enable = true;
        rice.enable = false;
        secrets.enable = true;
      };
      programs.build-client.enable = false;
    };
    # SSH setup requires sops-nix, which isn't supported on nix-on-droid
    # gipphe.programs.ssh.enable = lib.mkForce false;
  };
  hm = {
    home = {
      sessionVariables.XDG_RUNTIME_DIR = "${config.gipphe.homeDirectory}/.run";
      activation."sops-nix-droid-fix" = lib.hm.dag.entryAfter [ "filesChanged" ] ''
        run ${config.systemd.user.services.sops-nix.Service.ExecStart}
      '';
    };
    programs.fish.shellInit = lib.mkBefore ''
      mkdir -p '${config.home.sessionVariables."XDG_RUNTIME_DIR"}'
    '';
  };
  system-droid.system.stateVersion = lib.mkForce "24.05";
}
