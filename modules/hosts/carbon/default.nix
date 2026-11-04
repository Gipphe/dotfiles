{ den, ... }:
{
  # TODO: Fix for nix-on-droid
  # den.hosts.aarch64-linux.carbon = {
  #   users.nix-on-droid = {
  #     homeDirectory = "/data/data/com.termux.nix/files/home";
  #   };
  # };

  den.aspects.carbon = {
    includes = [
      den.aspects.profiles.android
      den.aspects.profiles.core
      den.aspects.profiles.secrets

      den.aspects.programs.direnv
      den.aspects.programs.eza
      den.aspects.programs.giphtvim
      den.aspects.programs.git
      den.aspects.programs.jq
      den.aspects.programs.jujutsu
      den.aspects.programs.less
      den.aspects.programs.nushell
      den.aspects.programs.ssh
      den.aspects.programs.zoxide
    ];
    homeManager =
      { user }:
      {
        lib,
        pkgs,
        config,
        ...
      }:
      {
        home = {
          sessionVariables.XDG_RUNTIME_DIR = "${user.homeDirectory}/.run";
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
        programs.nushell.extraConfig = ''
          mkdir "${config.home.sessionVariables."XDG_RUNTIME_DIR"}"
        '';
      };
    nixOnDroid = { lib, ... }: {
      system.stateVersion = lib.mkForce "24.05";
    };
  };
}
