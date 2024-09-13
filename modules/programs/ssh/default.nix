{
  util,
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (builtins) map concatStringsSep;
  raw_services = [
    "github"
    "gitlab"
    "codeberg"
  ];
  services = map (x: "${x}.ssh") raw_services;
  mkSecret = service: {
    sopsFile = ../../../secrets/${config.gipphe.hostName}-${service};
    mode = "400";
    format = "binary";
  };

  ssh_secrets = lib.filterAttrs (k: _: lib.hasSuffix ".ssh" k) config.sops.secrets;
  ssh_keys = concatStringsSep " " (lib.mapAttrsToList (_: v: "'${v.path}'") ssh_secrets);

  ssh-env-path = "${config.home.homeDirectory}/.ssh/agent-environment";
  read-ssh-env = util.writeFishApplication {
    name = "read-ssh-env";
    runtimeInputs = [ pkgs.coreutils ];
    runtimeEnv.SSH_ENV = ssh-env-path;
    text = # fish
      ''
        set -l lines $(cat $SSH_ENV | string split '\n')
        for line in $lines
          if string match -qr '^#'
            continue
          end
          set -l assignment (
            echo $line |
              string split -f1 ';' |
              string split '='
          )
          if test "$(count $assignment)" -lt 2
            continue
          end
          set -l key $assignment[1]
          set -l value $assignment[2]
          eval "set -gx $key $value"
        end
      '';
  };

  start-ssh-agent = util.writeFishApplication {
    name = "start-ssh-agent";
    runtimeInputs =
      (with pkgs; [
        coreutils
        gnused
        procps
      ])
      ++ [ read-ssh-env ]
      ++ lib.optional (!pkgs.stdenv.isDarwin) pkgs.openssh;
    runtimeEnv.SSH_ENV = ssh-env-path;
    text = # fish
      ''
        set -l old_pid (pgrep ssh-agent)
        if test -n "$old_pid"
          echo "ssh-agent: untracked agent already running. Killing it."
          kill $old_pid
        end
        echo "ssh-agent: starting new agent..."
        ssh-agent | sed 's/^echo/#echo/' >"$SSH_ENV"
        chmod 600 "$SSH_ENV"
        read-ssh-env "$SSH_ENV"
        echo "ssh-agent: started"
      '';
  };

  init-ssh-agent = util.writeFishApplication {
    name = "init-ssh-agent";
    runtimeInputs =
      (with pkgs; [
        procps
        gnugrep
      ])
      ++ [
        read-ssh-env
        start-ssh-agent
      ];
    runtimeEnv.SSH_ENV = ssh-env-path;
    text = # fish
      ''
        # If SSH_AUTH_SOCK is set, we do not need to do anything
        if test -n "$SSH_SOCK_AUTH"
            return
        end

        # Source SSH settings, if applicable
        if test -f "$SSH_ENV"
            read-ssh-env "$SSH_ENV"
            ps -ef | grep $SSH_AGENT_PID | grep 'ssh-agent$' >/dev/null
            if test "$status" != 0
                start-ssh-agent
            end
        else
            start-ssh-agent
        end
      '';
  };
  add-ssh-keys-to-agent = pkgs.writeShellApplication {
    name = "add-ssh-keys-to-agent";
    runtimeInputs = lib.optional (!pkgs.stdenv.isDarwin) config.programs.ssh.package;
    text = ''
      ssh-add ${ssh_keys} &>/dev/null
    '';
  };
in
util.mkProgram {
  name = "ssh";

  hm = {
    home.packages = [
      read-ssh-env
      start-ssh-agent
      init-ssh-agent
      add-ssh-keys-to-agent
    ];
    programs = {
      ssh = {
        enable = true;
        package = pkgs.openssh;
        addKeysToAgent = "yes";
        matchBlocks = lib.genAttrs services (s: {
          user = "git";
          identityFile = config.sops.secrets.${s}.path;
          identitiesOnly = true;
        });
      };
      fish = {
        shellInit = # fish
          ''
            ${lib.getExe init-ssh-agent}
            ${lib.getExe add-ssh-keys-to-agent}
          '';
      };
    };

    sops.secrets = lib.mkIf config.gipphe.environment.secrets.enable (
      lib.concatMapAttrs (k: v: { ${k} = v; }) (lib.genAttrs services mkSecret)
    );
  };

  system-nixos.programs.ssh.startAgent = true;
}
