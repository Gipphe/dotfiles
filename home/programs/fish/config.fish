#!/usr/bin/env fish

set fish_greeting ''
set -gx PAGER 'less -FRX'
# set -gx EDITOR nvim
set -gx GPG_TTY (tty)

if test -n "$TMUX"
    set -x DISABLE_AUTO_TITLE true
end

function not_in_path --argument-names dir
    if contains -- $dir $PATH
        return 1
    else if set -q fish_user_path $dir
        return 1
    else
        return 0
    end
end

# fish_add_path "$HOME/.nix-profile/bin"

# if test -e $HOME/.nix-profile/etc/profile.d/nix.sh
#     source $HOME/.nix-profile/etc/profile.d/nix.sh
# end

# if not_in_path "$HOME/google-cloud-sdk/bin"; and test -f "$HOME/google-cloud-sdk/path.fish.inc"
#     source "$HOME/google-cloud-sdk/path.fish.inc"
# end
#
# if test -f "$HOME/google-cloud-sdk/completion.fish.inc"
#     source "$HOME/google-cloud-sdk/completion.fish.inc"
# end

# set -gx BREW_BIN
# if test "$(uname)" = Darwin
#     set BREW_BIN /opt/homebrew/bin
# else
#     set BREW_BIN /home/linuxbrew/.linuxbrew/bin
# end

# set -gx BREW $BREW_BIN/brew
# if test -z "$BREW_INITIALIZED"
#     eval ($BREW shellenv)
#     set -gx BREW_INITIALIZED yes
#     echo "brew initialized" >&2
# end

# Set aliases
if type -q codium
    abbr --add code codium
end

alias docker_clean_images 'docker rmi (docker images -a --filter=dangling=true -q)'
alias docker_clean_ps 'docker rm (docker ps --filter=status=exited --filter=status=created -q)'
alias docker_clean_testcontainer 'docker rmi -f (docker images --filter="reference=*-*-*-*-*:*-*-*-*-*" --format "{{ .ID }}" | sort | uniq)'
alias docker_pull_images "docker images --format '{{.Repository}}:{{.Tag}}' | xargs -n 1 -P 1 docker pull"
abbr --add k kubectl
abbr --add kn kubens
abbr --add kcx kubectx
function reload_shell --no-scope-shadowing
    source ~/.config/fish/config.fish
end
abbr --add vim nvim
abbr --add tf terraform
abbr --add mux tmuxinator
alias nix-health 'nix run "github:juspay/nix-browser#nix-health"'
abbr --add gron fastgron
abbr --add rmz -- find . -name "'*Zone.Identifier'" -type f -delete

# Install direnv hook
if command -q direnv
    eval (direnv hook fish)
end

# Install asdf hook
# source ($BREW --prefix)/opt/asdf/libexec/asdf.fish

# Add Ruby gems to path
# command -q gem
# and begin
#     if gem environment home &>/dev/null
#         fish_add_path "$(gem environment home)/bin"
#     end
#     if gem environment user_gemhome &>/dev/null
#         fish_add_path "$(gem environment user_gemhome)/bin"
#     end
# end

# fish_add_path "$HOME/.cargo/bin"
# fish_add_path "$HOME/Library/Application Support/Coursier/bin"
# fish_add_path "$HOME/.local/share/coursier/bin"
# fish_add_path "$HOME/Library/Application Support/JetBrains/Toolbox/scripts"
# fish_add_path "$HOME/.ghcup/bin"
# fish_add_path "$HOME/.local/bin"

# if test "$(uname)" = Darwin
#     # Expose libiconv to linkers that require it.
#     set --path -gx LIBRARY_PATH $LIBRARY_PATH $(brew --prefix)/lib $(brew --prefix)/opt/libiconv/lib
# end

# Add jj shell completion
command -q jj
and begin
    jj util completion fish 2>/dev/null | source
    or jj util completion --fish | source
end

# Convert llava, mistral, and wizardcoder functions
if command -q llava.llamafile
    function llava
        if test -z "$argv[1]"
            echo "Image path parameter missing"
            return 1
        end
        if test -z "$argv[2]"
            echo "Prompt parameter missing"
            return 1
        end
        set -l LLAVA $(command -v llava.llamafile)
        set -l prompt "
### User: $argv[2]
### Assistant:
"
        command $LLAVA --image $argv[1] -p $prompt --silent-prompt 2>/dev/null
    end
end

if command -q mistral.llamafile
    function mistral
        if test -z "$argv[1]"
            echo "Prompt parameter missing"
            return 1
        end
        set -l MISTRAL $(command -v mistral.llamafile)
        command $MISTRAL -p "[INST] $argv[1] [/INST]" --silent-prompt 2>/dev/null
    end
end

if command -q wizardcoder.llamafile
    function wizardcoder
        if test -z "$1"
            echo "Prompt parameter missing"
            return 1
        end
        set -l WIZARDCODER $(command -v wizardcoder.llamafile)
        set -l prompt "
Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
$1

### Response:
"

        command $WIZARDCODER -p $prompt --silent-prompt 2>/dev/null
    end
end

# if command -q bass
#     if ! command -q coursier
#         bass eval ($BREW_BIN/coursier setup --env)
#     end
# end

# SSH config
source ~/.config/fish/functions/init_ssh_agent.fish
if functions -q init_ssh_agent
    init_ssh_agent
end

# Initialize zoxide
zoxide init --cmd cd fish | source
