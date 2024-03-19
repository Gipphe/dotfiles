#!/usr/bin/env fish

set -gx SSH_ENV "$HOME/.ssh/agent-environment"

function __read_ssh_env
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
end

function __start_agent
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
end

function init_ssh_agent
    # Source SSH settings, if applicable
    if test -f "$SSH_ENV"
        __read_ssh_env "$SSH_ENV"
        #ps ${SSH_AGENT_PID} doesn't work under cywgin
        ps -ef | grep $SSH_AGENT_PID | grep 'ssh-agent$' >/dev/null
        if test "$status" != 0
            __start_agent
        end
    else
        __start_agent
    end
    ssh-add (find ~/.ssh -type f -name '*.ssh') &>/dev/null
end
