{
  util,
  lib,
  config,
  pkgs,
  ...
}:
let
  raw_services = [
    "github"
    "gitlab"
    "codeberg"
  ];
  services = builtins.map (x: "${x}.ssh") raw_services;
  mkSecret = service: {
    sopsFile = ../../../../secrets/${config.gipphe.hostName}-${service};
    mode = "400";
    format = "binary";
  };

  ssh_secrets = lib.filterAttrs (k: _: lib.hasSuffix ".ssh" k) config.sops.secrets;
  ssh_keys = builtins.concatStringsSep " " (lib.mapAttrsToList (_: v: v.path) ssh_secrets);
in
util.mkProgram {
  name = "ssh";

  hm = {
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
        functions = {
          add_ssh_keys_to_agent = "${config.programs.ssh.package}/bin/ssh-add ${ssh_keys} &>/dev/null";
          __start_agent = # fish
            ''
              set -l old_pid (pgrep ssh-agent)
              if test -n "$old_pid"
                  echo "ssh-agent: untracked agent already running. Killing it."
                  kill $old_pid
              end
              echo "ssh-agent: starting new agent..."
              ssh-agent | sed 's/^echo/#echo/' >"$SSH_ENV"
              chmod 600 "$SSH_ENV"
              __read_ssh_env "$SSH_ENV"
              echo "ssh-agent: started"
            '';
          __read_ssh_env = # fish
            ''
              set -l SSH_ENV $argv[1]
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
          init_ssh_agent = # fish
            ''
              # If SSH_AUTH_SOCK is set, we do not need to do anything
              if test -n "$SSH_SOCK_AUTH"
                  return
              end

              # Source SSH settings, if applicable
              if test -f "$SSH_ENV"
                  __read_ssh_env "$SSH_ENV"
                  ps -ef | grep $SSH_AGENT_PID | grep 'ssh-agent$' >/dev/null
                  if test "$status" != 0
                      __start_agent
                  end
              else
                  __start_agent
              end
            '';
        };
        shellInit = # fish
          lib.mkAfter ''
            init_ssh_agent
            add_ssh_keys_to_agent
          '';
      };
    };

    sops.secrets = lib.mkIf config.gipphe.environment.secrets.enable (
      lib.concatMapAttrs (k: v: { ${k} = v; }) (lib.genAttrs services mkSecret)
    );
  };

  system-nixos.programs.ssh.startAgent = true;
}
