function add_ssh_keys_to_agent
    ssh-add (find -L $HOME/.ssh -type f -name '*.ssh') &>/dev/null
end
