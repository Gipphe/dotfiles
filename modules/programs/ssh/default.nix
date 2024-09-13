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
        shellInit = # fish
          ''
            init-ssh-agent
            add-ssh-keys-to-agent
          '';
        functions =
          let
            test = "${pkgs.coreutils}/bin/test";
            pgrep = "${pkgs.procps}/bin/pgrep";
            kill = "${pkgs.coreutils}/bin/kill";
            sed = "${pkgs.gnused}/bin/sed";
            chmod = "${pkgs.coreutils}/bin/chmod";
            ps = "${pkgs.procps}/bin/ps";
            grep = "${pkgs.gnugrep}/bin/grep";
            ssh-add = if (!pkgs.stdenv.isDarwin) then "${pkgs.openssh}/bin/ssh-add" else "ssh-add";
          in
          {
            read-ssh-env = # fish
              ''
                set -l lines $(${pkgs.coreutils}/bin/cat ${ssh-env-path} | string split '\n')
                for line in $lines
                  if string match -qr '^#'
                    continue
                  end
                  set -l assignment (
                    echo $line |
                      string split -f1 ';' |
                      string split '='
                  )
                  if ${test} "$(count $assignment)" -lt 2
                    continue
                  end
                  set -l key $assignment[1]
                  set -l value $assignment[2]
                  eval "set -gx $key $value"
                end
              '';
            start-ssh-agent =
              let
                ssh-agent = if (!pkgs.stdenv.isDarwin) then "${pkgs.openssh}/bin/ssh-agent" else "ssh-agent";
              in
              # fish
              ''
                set -l old_pid (${pgrep} 'ssh-agent')
                if ${test} -n "$old_pid"
                  echo "ssh-agent: untracked agent already running. Killing it."
                  ${kill} $old_pid
                end
                echo "ssh-agent: starting new agent..."
                ${ssh-agent} | ${sed} 's/^echo/#echo/' >"${ssh-env-path}"
                ${chmod} 600 "${ssh-env-path}"
                read-ssh-env "${ssh-env-path}"
                echo "ssh-agent: started"
              '';
            init-ssh-agent = # fish
              ''
                # If SSH_AUTH_SOCK is set, we do not need to do anything
                if ${test} -n "$SSH_SOCK_AUTH"
                  return
                end

                # Source SSH settings, if applicable
                if ${test} -f "${ssh-env-path}"
                  read-ssh-env "${ssh-env-path}"
                  ${ps} -ef | ${grep} $SSH_AGENT_PID | ${grep} 'ssh-agent$' >/dev/null
                  if ${test} "$status" != 0
                    start-ssh-agent
                  end
                else
                  start-ssh-agent
                end
              '';
            add-ssh-keys-to-agent =
              # fish
              ''
                ${ssh-add} ${ssh_keys} &>/dev/null
              '';
          };
      };
    };

    sops.secrets = lib.mkIf config.gipphe.environment.secrets.enable (
      lib.concatMapAttrs (k: v: { ${k} = v; }) (lib.genAttrs services mkSecret)
    );
  };

  system-nixos.programs.ssh.startAgent = true;
}
