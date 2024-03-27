set fish_greeting ''

if test -n "$TMUX"
    set -x DISABLE_AUTO_TITLE true
end

set -gx SSH_ENV "$HOME/.ssh/agent-environment"

init_ssh_agent
add_ssh_keys_to_agent
