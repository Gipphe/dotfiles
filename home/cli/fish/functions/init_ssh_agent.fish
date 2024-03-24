function init_ssh_agent
    # If SSH_AUTH_SOCK is set, we do not need to do anything
    if test -n "$SSH_SOCK_AUTH"
        return
    end

    echo "ssh-agent: initializing..."
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

    add_ssh_keys_to_agent
end
