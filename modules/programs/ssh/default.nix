{
  util,
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.gipphe.programs.ssh;
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
  ssh_key_paths = lib.mapAttrsToList (_: v: "'${v.path}'") ssh_secrets;
  ssh_keys = concatStringsSep " " ssh_key_paths;
  ssh-env-path = "${config.home.homeDirectory}/.ssh/agent-environment";
in
util.mkProgram {
  name = "ssh";

  options.gipphe.programs.ssh.lovdata.enable = lib.mkEnableOption "Lovdata configs for SSH";

  hm = {
    programs = {
      ssh = {
        enable = true;
        package = pkgs.openssh;
        addKeysToAgent = "yes";
      };
      # keychain = {
      #   enable = true;
      #   keys = [ "id_ed25519" ] ++ ssh_key_paths;
      # };
      fish = {
        shellInit = # fish
          ''
            init-ssh-agent
            add-ssh-keys-to-agent
          '';
        functions =
          let
            inherit (pkgs.stdenv.hostPlatform) isDarwin;
            test = "${pkgs.coreutils}/bin/test";
            pgrep = if isDarwin then "pgrep" else "${pkgs.procps}/bin/pgrep";
            kill = if isDarwin then "kill" else "${pkgs.coreutils}/bin/kill";
            sed = "${pkgs.gnused}/bin/sed";
            chmod = if isDarwin then "chmod" else "${pkgs.coreutils}/bin/chmod";
            ssh-add = if isDarwin then "ssh-add" else "${pkgs.openssh}/bin/ssh-add";
            cat = if isDarwin then "cat" else "${pkgs.coreutils}/bin/cat";
          in
          {
            read-ssh-env = # fish
              ''
                set -l lines $(${cat} ${ssh-env-path} | string split '\n')
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
                ssh-agent = if (!isDarwin) then "${pkgs.openssh}/bin/ssh-agent" else "ssh-agent";
              in
              # fish
              ''
                set -l old_pid (${pgrep} 'ssh-agent')
                if ${test} -n "$old_pid"
                  echo "ssh-agent: untracked agent already running. Killing it." >&2
                  ${kill} $old_pid
                end
                echo "ssh-agent: starting new agent..." >&2
                ${ssh-agent} | ${sed} 's/^echo/#echo/' >"${ssh-env-path}"
                ${chmod} 600 "${ssh-env-path}"
                read-ssh-env "${ssh-env-path}"
                echo "ssh-agent: started" >&2
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
                  set -l pid $(${pgrep} 'ssh-agent$')
                  if test "$pid" != "$SSH_AGENT_PID"
                    start-ssh-agent
                  end
                else
                  start-ssh-agent
                end
              '';
            add-ssh-keys-to-agent = # fish
              ''
                ${ssh-add} ${ssh_keys} &>/dev/null
              '';
          };
      };
    };

    sops.secrets = lib.mkMerge [
      (lib.mkIf config.gipphe.environment.secrets.enable (
        lib.concatMapAttrs (k: v: { ${k} = v; }) (lib.genAttrs services mkSecret)
      ))
      (lib.mkIf cfg.lovdata.enable {
        "lovdata-gitlab.ssh" = mkSecret "lovdata-gitlab.ssh";
      })
    ];
  };

  system-nixos.programs.ssh.startAgent = true;
}
