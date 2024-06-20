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
