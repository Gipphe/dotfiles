{
  lib,
  config,
  util,
  pkgs,
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
        core.enable = true;
        fonts.enable = true;
        secrets.enable = true;
      };
      programs = {
        direnv.enable = true;
        eza.enable = true;
        fish.enable = true;
        giphtvim.enable = true;
        git.enable = true;
        jq.enable = true;
        jujutsu.enable = true;
        less.enable = true;
        ssh.enable = true;
        zoxide.enable = true;
      };
    };
  };
  hm = {
    home = {
      sessionVariables.XDG_RUNTIME_DIR = "${config.gipphe.homeDirectory}/.run";
      activation."sops-nix-droid-fix" =
        let
          script = pkgs.writeShellScript "exec-secrets" ''
            export XDG_RUNTIME_DIR="${config.home.sessionVariables."XDG_RUNTIME_DIR"}"
            mkdir -p "$XDG_RUNTIME_DIR"
            ${builtins.elemAt config.systemd.user.services.sops-nix.Service.ExecStart 0}
          '';
        in
        lib.hm.dag.entryAfter [ "filesChanged" ] ''
          run ${script}
        '';
    };
    programs.fish.shellInit = lib.mkBefore ''
      mkdir -p '${config.home.sessionVariables."XDG_RUNTIME_DIR"}'
    '';
  };
  system-droid.system.stateVersion = lib.mkForce "24.05";
}
