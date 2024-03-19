#!/usr/bin/env fish

function mistral
    if not command -q mistral.llamafile
        echo "mistral.llamafile not in PATH" >&2
        exit 1
    end

    if test -z "$argv[1]"
        echo "Prompt parameter missing"
        return 1
    end
    set -l MISTRAL $(command -v mistral.llamafile)
    command $MISTRAL -p "[INST] $argv[1] [/INST]" --silent-prompt 2>/dev/null
end
